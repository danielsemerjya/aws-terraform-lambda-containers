variable "location" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = contains(["eu-central-1"], var.location)
    error_message = "Only eu-central-1 are allowed."
  }
}

variable "env_name" {
  description = "The name of the environment, e.g. dev, test, or prod."
  default     = "dev"
}

variable "api_gw_name" {
  description = "API Gateway name"
}

variable "functions" {
  description = "List of functions to deploy - key should include env name for example profile_faker_dev - its crucial."
  type = map(object({
    function_name                  = string
    function_source_code_full_path = string # full path to the function source code where Dockerfile are stored.
    timeout                        = number
    route_prefix                   = string
    memory_size                    = number
    environment_variables          = map(string)
  }))
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    "Owner"   = "Daniel"
    "Project" = "givemeart"
  }
}
