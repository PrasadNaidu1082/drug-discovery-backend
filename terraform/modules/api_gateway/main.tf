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

resource "aws_api_gateway_integration" "upload_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.upload_resource.id
  http_method             = aws_api_gateway_method.upload_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.upload_lambda_arn

  request_templates = {
    "text/csv" = <<EOF
{
  "body": "$util.base64Encode($input.body)"
}
EOF
  }
}

resource "aws_api_gateway_integration" "retrieve_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.retrieve_resource.id
  http_method             = aws_api_gateway_method.retrieve_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.retrieve_lambda_arn
}

resource "aws_api_gateway_method_response" "upload_post_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.upload_resource.id
  http_method = aws_api_gateway_method.upload_post.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "retrieve_get_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.retrieve_resource.id
  http_method = aws_api_gateway_method.retrieve_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "upload_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.upload_resource.id
  http_method = aws_api_gateway_method.upload_post.http_method
  status_code = "200"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "retrieve_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.retrieve_resource.id
  http_method = aws_api_gateway_method.retrieve_get.http_method
  status_code = "200"
  response_templates = {
    "application/json" = ""
  }
}
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.upload_post_integration,
    aws_api_gateway_integration.retrieve_get_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = "prod"
}

resource "aws_api_gateway_stage" "prod_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}

variable "upload_lambda_arn" {}
variable "retrieve_lambda_arn" {}

output "api_url" {
  value = aws_api_gateway_stage.prod_stage.invoke_url
}
