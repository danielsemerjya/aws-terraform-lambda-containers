locals {
  function_name_env = "${var.function_name}-${var.env_name}"
}

resource "aws_ecr_repository" "this" {
  name                 = "rp-${local.function_name_env}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = merge(
    var.tags,
    {
      Name = "rp-${local.function_name_env}"
    },
  )
  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOF
      image_digests=$(aws ecr list-images --repository-name "${self.name}" --query 'imageIds[*].imageDigest' --output text)
      for digest in $image_digests; do
        aws ecr batch-delete-image --repository-name "${self.name}" --image-ids imageDigest=$digest
      done
	    EOF
  }
}

data "aws_caller_identity" "current" {}

data "archive_file" "this" {
  # Archive just for hash counting to trigger docker build
  type        = "zip"
  excludes    = ["__pycache__"]
  source_dir  = var.function_source_code_full_path
  output_path = "${path.root}/builds/${local.function_name_env}.zip"
}

resource "null_resource" "code_hash" {
  triggers = {
    sha256 = data.archive_file.this.output_base64sha256
  }
}

resource "null_resource" "docker_packaging" {

  provisioner "local-exec" {
    command = <<EOF
      cd ${var.function_source_code_full_path}
	    aws ecr get-login-password --region ${var.location} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.location}.amazonaws.com
	    docker build -t "${aws_ecr_repository.this.repository_url}:latest" -f Dockerfile .
	    docker push "${aws_ecr_repository.this.repository_url}:latest"
	    EOF
  }

  lifecycle {
    replace_triggered_by = [null_resource.code_hash]
  }

  depends_on = [
    aws_ecr_repository.this,
  ]
}

resource "aws_lambda_function" "this" {
  function_name = "fc-${local.function_name_env}"
  timeout       = var.timeout
  image_uri     = "${aws_ecr_repository.this.repository_url}:latest"
  package_type  = "Image"
  memory_size   = var.memory_size
  role          = aws_iam_role.this.arn

  tags = merge(
    var.tags,
    {
      Name = "${local.function_name_env}"
    },
  )

  environment {
    variables = var.environment_variables
  }

  lifecycle {
    replace_triggered_by = [null_resource.code_hash]
  }

  depends_on = [
    null_resource.docker_packaging,
  ]
}

data "aws_iam_policy_document" "lambda_exec" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.location}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/fc-${local.function_name_env}:*"]
  }
}


resource "aws_iam_role" "this" {
  name = "function-role-${local.function_name_env}"

  assume_role_policy = data.aws_iam_policy_document.lambda_exec.json

  inline_policy {
    name   = "lambda_logging"
    policy = data.aws_iam_policy_document.lambda_logging.json
  }

  tags = merge(
    var.tags,
    {
      Name = "function-role-${local.function_name_env}"
    },
  )
}


resource "aws_cloudwatch_log_group" "incoming_data_handler" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 14
}
