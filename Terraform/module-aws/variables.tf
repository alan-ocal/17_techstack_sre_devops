variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "s3_bucket_name" {
  type    = string
  default = "nodejs-alert-deployment-package"
}

variable "s3_bucket_key" {
  type    = string
  default = "nodejs-alert-deployment-package.zip"
}

variable "lambda_package_path" {
  type = string
}

variable "jsm_operations_api_key" {
  type      = string
  sensitive = true
}

variable "jsm_operations_api_endpoint" {
  type    = string
  default = "https://api.atlassian.com/jsm/ops/integration/v2/alerts"
}

# variable "slack_webhook_url" {
#   type      = string
#   sensitive = true
# }

variable "lambda_function_name" {
  type    = string
  default = "ps-alert"
}

variable "lambda_function_handler" {
  type    = string
  default = "index.handlePRCreation"
}

variable "lambda_function_runtime" {
  type    = string
  default = "nodejs18.x"
}

variable "APIGW_platform_name" {
  type    = string
  default = "alert-deployment"
}
