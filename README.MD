Based on the provided details and aiming to enhance the appeal and clarity of the README.md for the `aws-terraform-lambda-containers` project, here's a revised version:

---

# AWS Terraform Lambda Containers

Welcome to the AWS Terraform Lambda Containers project! This innovative solution leverages the power of Terraform, AWS API Gateway, Lambda, and Docker to deploy a serverless API that's both scalable and efficient. Dive into the world of serverless architecture with ease and see your Docker containers come to life as Lambda functions.

## 🚀 Quick Start

Getting started with this project is as simple as modifying a single file and running Terraform. Here's how:

1. **Prepare Your Environment**: Ensure you have Terraform, Docker, and AWS CLI installed on your machine.
2. **Configure**: Open `dev.tf` and adjust the settings to match your project's needs.
3. **Deploy**: Run Terraform to deploy your Docker image as a Lambda function, automatically pushed to AWS ECR and connected to an API Gateway endpoint.

Example configuration in `dev.tf`:

```hcl
api_gw_name = "simple-api-gw"

functions = {
  generator = {
    function_name                  = "app"
    function_source_code_full_path = "/path/to/your/source/app"
    timeout                        = 30
    route_prefix                   = "/app"
    memory_size                    = 512
    environment_variables = {
      OPENAI_API_KEY = "your-openai-api-key"
    }
  }
}
```

Add more objects to the `functions` variable to deploy additional Lambdas and expose them through new API Gateway endpoints.

## 📦 Requirements

- **Terraform**: For infrastructure as code.
- **Docker**: To containerize your application.
- **AWS CLI**: To interact with AWS services.

## 📂 Project Structure

- **.gitignore**: Lists files and directories ignored by git.
- **main.tf**: Terraform configuration for setting up API Gateway and Lambda functions.
- **modules/lambda**: Contains Terraform configurations for provisioning Lambda functions.
- **source/app**: The source code of your Lambda function, including Dockerfile, requirements, and the main Python script.

## 🛠️ Building and Deploying

1. **Build Your Docker Image**: The Dockerfile in `source/app` sets up your Lambda's environment.
2. **Deploy with Terraform**: Run `terraform apply` to deploy your infrastructure.

## 📚 Learn More

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Lambda with Container Images](https://docs.aws.amazon.com/lambda/latest/dg/lambda-images.html)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📬 Contact

Daniel Semerjyan - https://www.linkedin.com/in/daniel-semerjyan/

Project Link: [https://github.com/danielsemerjya/aws-terraform-lambda-containers](https://github.com/danielsemerjya/aws-terraform-lambda-containers)
