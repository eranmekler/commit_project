# # example for api gateway. need to insert !!!"aws_api_gateway_authorizer"!!!
# # from the documantion:
# # aws_api_gateway_resource can be imported using REST-API-ID/RESOURCE-ID, e.g.

# # Variables
# variable "myregion" {
#   description = "region"
#   type        = string
#   default     = "eu-west-1"
# }

# variable "accountId" {
#   description = "accountid"
#   type        = string
#   default     = "141521707460"
# }

# # API Gateway
# resource "aws_api_gateway_rest_api" "api_rest" {
#   name = "myapi"
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.api_rest.id
#   resource_id   = aws_api_gateway_rest_api.api_rest.root_resource_id
#   http_method   = "GET"
#   authorization = "NONE"
  
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api_rest.id
#   resource_id             = aws_api_gateway_rest_api.api_rest.root_resource_id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "GET"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.LambdaAuth.invoke_arn
# }

# # Lambda
# resource "aws_lambda_permission" "apigw_lambda" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.LambdaAuth.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api_rest.id}/*/${aws_api_gateway_method.method.http_method}/"
# }
# # resource "aws_api_gateway_deployment" "api_deploy" {
# #   rest_api_id = aws_api_gateway_rest_api.api_rest.id
# #   depends_on = [
# #         aws_api_gateway_method.method,
# #         aws_api_gateway_integration.integration
# #       ]
# # }

# # resource "aws_api_gateway_stage" "api_stage" {
# #   deployment_id = aws_api_gateway_deployment.api_deploy.id
# #   rest_api_id   = aws_api_gateway_rest_api.api_rest.id
# #   stage_name    = "auth"
# # }

# data "aws_iam_policy_document" "lambda_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "iam_for_lambda_auth" {
#   name               = "iam_for_lambda_auth"
#   assume_role_policy = data.aws_iam_policy_document.lambda_role.json
# }


# resource "aws_lambda_function" "LambdaAuth" {
#   # If the file is not in the current working directory you will need to include a
#   # path.module in the filename.
#   filename      = "LambdaAuth.zip"
#   function_name = "LambdaAuth"
#   role          = aws_iam_role.iam_for_lambda_auth.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime = "python3.10"
#   source_code_hash = filebase64sha256("LambdaAuth.zip")


#   environment {
#     variables = {
#       foo = "bar"
#     }
#   }
# }
# resource "aws_api_gateway_method_response" "response_200" {
#   rest_api_id = aws_api_gateway_rest_api.api_rest.id
#   resource_id = aws_api_gateway_rest_api.api_rest.root_resource_id
#   http_method = aws_api_gateway_method.method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_integration_response" "integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.api_rest.id
#   resource_id = aws_api_gateway_rest_api.api_rest.root_resource_id
#   http_method = aws_api_gateway_method.method.http_method
#   status_code = aws_api_gateway_method_response.response_200.status_code
#   depends_on = [ aws_api_gateway_method_response.response_200 ]
# }
# resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
#   role       = aws_iam_role.iam_for_lambda_auth.name
#   policy_arn = aws_iam_policy.LogPolicyLambda.arn
# }