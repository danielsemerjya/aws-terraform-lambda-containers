# aws-terraform-lambda-containers

Use Terraform, AWS APi Gateway, Lambda and Docker to produce serverless API.

## How to use it

Simply modify file dev.tf and launch terraform.

With this setup it will build your local Dockerimage, push it to AWS ECR (Images repository) and launch lambda.
Each lambda will be plugged as and endpoint to the API Gateway.

```
api_gw_name = "simple-api-gw"

functions = {
  generator = {
    function_name                  = "app"
    function_source_code_full_path = "/home/azarjaved/dev/creativity/aws-terraform-lambda-containers/source/app"
    timeout                        = 30
    route_prefix                   = "/app"
    memory_size                    = 512
    environment_variables = {
      OPENAI_API_KEY = "xxxx-xxx-xxxx-xxx"
    }
  }
}
```

Add next object to function variable to produce next lambda and plug it to other endpoint.

## Requirements

- Terraform
- Docker
- AWS CLI
