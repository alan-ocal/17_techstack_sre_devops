terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_object" "lambda_package" {
  bucket = var.s3_bucket_name
  key    = var.s3_bucket_key
  source = var.lambda_package_path
  etag   = filemd5(var.lambda_package_path)
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket = var.s3_bucket_name
  s3_key    = var.s3_bucket_key

  function_name = var.lambda_function_name
  handler       = var.lambda_function_handler
  runtime       = var.lambda_function_runtime
  role          = aws_iam_role.lambda.arn

  environment {
    variables = {
      JSM_OPERATIONS_API_KEY      = var.jsm_operations_api_key
      JSM_OPERATIONS_API_ENDPOINT = var.jsm_operations_api_endpoint
    }
  }

  depends_on = [
    aws_s3_object.lambda_package,
    aws_iam_role_policy_attachment.lambda_logging,
  ]
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

resource "aws_iam_role" "lambda" {
  name = "iam_for_lambda-${var.lambda_function_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "logging" {
  name = "lambda-logging-policy-${var.lambda_function_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logging.arn
}

