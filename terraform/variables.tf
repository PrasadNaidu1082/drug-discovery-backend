
variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for storing CSV files"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for storing drug discovery data"
  type        = string
}

variable "upload_lambda_name" {
  description = "Name of the Lambda function for uploading data"
  type        = string
}

variable "retrieve_lambda_name" {
  description = "Name of the Lambda function for retrieving data"
  type        = string
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}
