resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_gateway_name
  description = "Drug Discovery API"
}

resource "aws_api_gateway_resource" "upload_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_resource" "retrieve_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "data"
}

resource "aws_api_gateway_method" "upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.upload_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "retrieve_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.retrieve_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

variable "upload_lambda_arn" {}
variable "retrieve_lambda_arn" {}

output "api_url" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

