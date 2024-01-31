variable "function_name" {
  description = "Name of the Lambda function"
}

variable "function_source_code_full_path" {
  description = "The full path to the directory containing the function source code"
}

variable "location" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "eu-central-1"
}

variable "env_name" {
  description = "Environment name"
  type        = string
}
variable "environment_variables" {
  description = "Map of environmnent variables to pass to the Lambda function"
  type        = map(string)
  default     = {}
  sensitive   = true
  # Example
  # default = {
  #   "ENV" = "dev"
  # }
}

variable "memory_size" {
  description = "The amount of memory your Lambda Function has access to in MB."
  default     = 128
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  default     = 10
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
