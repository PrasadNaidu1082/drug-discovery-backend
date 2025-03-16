
variable "lambda_role_name" {
  description = "IAM Role name for the Lambda function"
  type        = string
}

variable "region" {
  description = "AWS region for deployment"
  type        = string
}
