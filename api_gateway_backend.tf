resource "aws_api_gateway_resource" "login_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_rest.id
  parent_id   = aws_api_gateway_rest_api.api_rest.root_resource_id
  path_part   = "login"
  depends_on = [ aws_api_gateway_deployment.api_deploy ]
}

resource "aws_api_gateway_method" "login_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_rest.id
  resource_id   = aws_api_gateway_resource.login_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_users_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_rest.id
  resource_id             = aws_api_gateway_resource.login_resource.id
  http_method             = aws_api_gateway_method.login_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.LambdaUsers.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda_users" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaUsers.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api_rest.id}/*/${aws_api_gateway_method.login_method.http_method}${aws_api_gateway_resource.login_resource.id}"
}

# resource "aws_api_gateway_deployment" "api_deploy_users" {
#   rest_api_id = aws_api_gateway_rest_api.api_rest.id

#   depends_on = [
#         aws_api_gateway_method.login_method,
#         aws_api_gateway_integration.lambda_users_integration
#       ]
# }

# resource "aws_api_gateway_stage" "api_stage_users" {
#   deployment_id = aws_api_gateway_deployment.api_deploy_users.id
#   rest_api_id   = aws_api_gateway_rest_api.api_rest.id
#   stage_name    = "login"
# }

resource "aws_iam_role" "iam_for_lambda_users" {
  name               = "iam_for_lambda_users"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}


resource "aws_lambda_function" "LambdaUsers" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "LambdaForUsers.zip"
  function_name = "LambdaForUsers"
  role          = aws_iam_role.iam_for_lambda_users.arn
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.10"
  source_code_hash = filebase64sha256("LambdaForUsers.zip")


  environment {
    variables = {
      foo = "bar"
    }
  }
}