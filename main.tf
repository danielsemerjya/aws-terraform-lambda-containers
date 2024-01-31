

module "lambdas" {
  for_each = var.functions

  source = "./modules/lambda"

  function_name                  = each.value.function_name
  env_name                       = var.env_name
  function_source_code_full_path = each.value.function_source_code_full_path
  memory_size                    = each.value.memory_size
  timeout                        = each.value.timeout

  environment_variables = each.value.environment_variables
  tags                  = var.tags
}

resource "aws_apigatewayv2_api" "this" {
  name          = "${var.api_gw_name}-${var.env_name}"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }
  depends_on = [module.lambdas]
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id

  name        = var.env_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.functions
  api_id   = aws_apigatewayv2_api.this.id

  integration_uri    = module.lambdas[each.key].invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.functions
  api_id   = aws_apigatewayv2_api.this.id

  route_key = "GET ${each.value.route_prefix}"
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.this.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "this" {
  for_each = var.functions

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdas[each.key].function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"

  lifecycle {
    replace_triggered_by = [aws_apigatewayv2_integration.this[each.key]]
  }
}

