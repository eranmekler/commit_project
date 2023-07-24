
# Create the API Gateway REST API

resource "aws_api_gateway_rest_api" "example_api" {
  name = "example_api"
}

# Define the 'auth' resource and its associated method and integration

resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "auth"
}

resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.example_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.example_resource.id
  http_method             = aws_api_gateway_method.example_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example_api.execution_arn}/*"

}
# Define the 'auth/login' resource and its associated method, integration and authorizer

resource "aws_api_gateway_resource" "example_resource_users" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_resource.example_resource.id
  path_part   = "login"
}

resource "aws_api_gateway_method" "example_method_users" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.example_resource_users.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "integration_users" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.example_resource_users.id
  http_method             = aws_api_gateway_method.example_method_users.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda_users.invoke_arn
}
# Provide necessary permissions for the API Gateway to invoke the Lambdas

resource "aws_lambda_permission" "apigw_lambda_users" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda_users.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.example_api.id}/*/GET/auth/login"


}
# Define cognito authorizer API gateway
resource "aws_api_gateway_authorizer" "demo" {
  name          = "demo"
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = ["arn:aws:cognito-idp:${var.myregion}:${var.accountId}:userpool/${aws_cognito_user_pool.commit_users.id}"]
}
# Deployment for API gateway
resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example_api.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.example_method,
    aws_api_gateway_integration.integration,
    aws_api_gateway_method.example_method_users,
    aws_api_gateway_integration.integration_users
  ]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  stage_name    = "dev"
}
