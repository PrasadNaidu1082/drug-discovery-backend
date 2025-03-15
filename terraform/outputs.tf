output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.dynamodb_table_name
}

output "upload_lambda_arn" {
  description = "ARN of the CSV upload Lambda"
  value       = module.lambda.upload_lambda_arn
}

output "retrieve_lambda_arn" {
  description = "ARN of the data retrieval Lambda"
  value       = module.lambda.retrieve_lambda_arn
}

output "api_gateway_url" {
  description = "Base URL of the API Gateway"
  value       = module.api_gateway.api_url
}

