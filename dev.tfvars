api_gw_name = "simple-api-gw"

functions = {
  generator = {
    function_name                  = "lambda_app"
    function_source_code_full_path = "/home/azarjaved/dev/creativity/aws-terraform-lambda-containers/source/app"
    timeout                        = 30
    route_prefix                   = "/app"
    memory_size                    = 512
    environment_variables = {
      OPENAI_API_KEY = "xxxx-xxx-xxxx-xxx"
    }
  }
}
