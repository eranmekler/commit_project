#Lambda Auth
resource "aws_lambda_function" "example_lambda" {
  function_name = "LambdaAuth"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "./python/LambdaAuth.zip"

}
resource "null_resource" "update_lambda_env" {
  triggers = {
    lambda_function_arn = aws_lambda_function.example_lambda.arn
  }
  provisioner "local-exec" {
    command = <<-EOT
      aws lambda update-function-configuration \
        --function-name ${aws_lambda_function.example_lambda.function_name} \
        --environment "Variables={API_URL=${aws_api_gateway_deployment.example.invoke_url}dev/auth/login,CLIENT_ID=${aws_cognito_user_pool_client.commit_client.id},CLIENT_SECRET=${aws_cognito_user_pool_client.commit_client.client_secret},REDIRECT_URI=${aws_cognito_user_pool_client.commit_client.default_redirect_uri},TOKEN_URL=https://${aws_cognito_user_pool_domain.commit_cognito_hosted_ui.domain}.auth.${var.myregion}.amazoncognito.com/oauth2/token}"
    EOT
  }
  depends_on = [ aws_cognito_user_pool_client.commit_client ]
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "LambdaAuthPolicy" {
  name = "LambdaAuthPolicy"
  role = aws_iam_role.lambda_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-west-1:141521707460:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-1:141521707460:log-group:/aws/lambda/LambdaAuth:*"
            ]
        }
    ]
}
)
}



# LambdaForUsers
resource "aws_lambda_function" "example_lambda_users" {
  function_name = "LambdaForUsers"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_role_users.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "./python/LambdaForUsers.zip"
  layers        = [aws_lambda_layer_version.lambda_layer.arn]
  environment {
    variables = {
     DYNAMO_TABLE_NAME = aws_dynamodb_table.commit_dynamo_db_table.name
     S3_BUCKET_NAME = aws_s3_bucket.commit_bucket.bucket
    }
  }
  
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "./python/jwtpackage.zip"
  layer_name = "lambda_layer_name"
  compatible_runtimes = ["python3.9"]
}
resource "aws_iam_policy" "LambdaPolicyUsers" {
  name        = "LambdaPolicyUsers"
  description = "Lambda policy"

  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPolicy",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:DescribeParameters"
            ],
            "Resource": "arn:aws:ssm:eu-west-1:141521707460:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:eu-west-1:141521707460:table/commit_db"
        },
        {
            "Sid": "S3BucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.commit_bucket.bucket}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-west-1:141521707460:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-1:141521707460:log-group:/aws/lambda/LambdaForUsers:*"
            ]
        }
    ]
}

)
}
resource "aws_iam_role" "lambda_role_users" {
  name               = "lambda_role_users"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda_param_users" {
  role       = aws_iam_role.lambda_role_users.name
  policy_arn = aws_iam_policy.LambdaPolicyUsers.arn
}
