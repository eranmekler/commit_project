# example for api gateway. need to insert !!!"aws_api_gateway_authorizer"!!!
# from the documantion:
# aws_api_gateway_resource can be imported using REST-API-ID/RESOURCE-ID, e.g.

# Variables
variable "myregion" {}

variable "accountId" {}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
}



resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.root_resource_id
  resource_id   = aws_api_gateway_rest_api.api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_lambda_function" "lambda" {
  filename      = "lambda.zip"
  function_name = "mylambda"
  role          = aws_iam_role.role.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.7"

  source_code_hash = filebase64sha256("lambda.zip")
}

# IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "myrole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}