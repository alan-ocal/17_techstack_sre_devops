terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
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

module "ps_alert_stack" {
  source = "./module-aws"

  aws_region                  = "eu-west-2"
  s3_bucket_name              = "nodejs-alert-deployment-package"
  s3_bucket_key               = "nodejs-alert-deployment-package.zip"
  lambda_package_path         = "${path.root}/nodejs-alert-deployment-package.zip"
  jsm_operations_api_key      = var.jsm_operations_api_key
  jsm_operations_api_endpoint = var.jsm_operations_api_endpoint
  # slack_webhook_url           = var.slack_webhook_url
  lambda_function_name    = "ps-alert"
  lambda_function_handler = "index.handlePRCreation"
  lambda_function_runtime = "nodejs18.x"
  APIGW_platform_name     = "alert-deployment"
}
