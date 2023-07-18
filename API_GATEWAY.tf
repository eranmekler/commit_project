# example for api gateway. need to insert !!!"aws_api_gateway_authorizer"!!!
# from the documantion:
# aws_api_gateway_resource can be imported using REST-API-ID/RESOURCE-ID, e.g.

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "My API"
  description = "Example API created using Terraform"
}

resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myresource"
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.my_resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "https://example.com/api"
}

resource "aws_api_gateway_deployment" "my_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}
