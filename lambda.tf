resource "aws_lambda_function" "example_lambda" {
  function_name = "LambdaAuth"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "LambdaAuth.zip"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/LambdaAuth"
  retention_in_days = 14
}
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
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

# LambdaForUsers
resource "aws_lambda_function" "example_lambda_users" {
  function_name = "LambdaForUsers"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role_users.arn
  handler       = "lambda_function.lambda_handler"
  filename      = "LambdaForUsers.zip"
  layers        = [aws_lambda_layer_version.lambda_layer.arn]

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}
resource "aws_cloudwatch_log_group" "example_users" {
  name              = "/aws/lambda/LambdaForUsers"
  retention_in_days = 14
}
resource "aws_iam_role_policy_attachment" "lambda_logs_users" {
  role       = aws_iam_role.lambda_role_users.name
  policy_arn = aws_iam_policy.lambda_logging.arn
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
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "jwtpackage.zip"
  layer_name = "lambda_layer_name"
  compatible_runtimes = ["python3.9"]
}