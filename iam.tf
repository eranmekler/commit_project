
# resource "aws_iam_policy" "LogPolicyLambda" {
#   name        = "cloudwatch-policy-logs-for-lambda"
#   description = "My cloudwatch policy"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "logs:CreateLogGroup",
#             "Resource": "arn:aws:logs:eu-west-1:141521707460:*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": [
#                 "arn:aws:logs:eu-west-1:141521707460:log-group:/aws/lambda/LambdaAuth:*"
#             ]
#         }
#     ]
# })
# }

# # resource "aws_iam_policy" "PolicyParamGet" {
# #   name        = "Take parameters from parameters store"
# #   description = "Take parameters from parameters store"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Sid": "VisualEditor0",
# #             "Effect": "Allow",
# #             "Action": [
# #                 "ssm:GetParameters",
# #                 "ssm:GetParameter",
# #                 "ssm:DescribeParameters"
# #             ],
# #             "Resource": "arn:aws:ssm:eu-west-1:141521707460:*"
# #         }
# #     ]
# # })
# # }
# # resource "aws_iam_policy" "PutItemsDynamoDb" {
# #   name        = "Put items in dynamodb table"
# #   description = "Put items in dynamodb table : username and time"

# #   # Terraform's "jsonencode" function converts a
# #   # Terraform expression result to valid JSON syntax.
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Effect": "Allow",
# #             "Action": [
# #                 "dynamodb:PutItem"
# #             ],
# #             "Resource": "arn:aws:dynamodb:eu-west-1:141521707460:table/commit_table"
# #         }
# #     ]
# # })
# # }
# # resource "aws_iam_policy" "WriteS3TimeLog" {
# #   name        = "Write to S3 bucket username file, and inside the login time"
# #   description = "Write to S3 bucket username file, and inside the login time"

  
# #   policy = jsonencode({
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Sid": "S3BucketAccess",
# #             "Effect": "Allow",
# #             "Action": [
# #                 "s3:PutObject"
# #             ],
# #             "Resource": [
# #                 "arn:aws:s3:::commit-yuval-eran-logs/*"
# #             ]
# #         }
# #     ]
# # })
# # }
