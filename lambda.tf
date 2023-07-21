
# resource "aws_lambda_function" "Commit_project" {
#   filename      = "lambda_function_payload.zip"
#   function_name = "Ommit_project"
#   role          =  aws_iam_role.lambda_s3ANDdynamo_access.arn
#   handler       = "exports.test"
#   description = "lambada to be triggerd. grands auth,write to s3 bucket read from dynamo db"

#   runtime = "python3.10" # to be changed?
#   tags = {
#     Name = "lambda_for_CommitProject"
#   }
#     # to be add and edit:
#     # invoke_arn - The ARN to be used for invoking Lambda Function from API Gateway
#     # - to be used in aws_api_gateway_integration's uri
# }



# # iam role lambda,currently s3 read&write FullAccess dynamo db read FullAccess

# resource "aws_iam_role" "lambda_s3ANDdynamo_access" {
#   name = "lambda_s3ANDdynamo_access"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   }{
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [   # to be edit!!!
#                 "s3:DeleteAccessPoint",
#                 "s3:DeleteAccessPointForObjectLambda",
#                 "s3:PutLifecycleConfiguration",
#                 "dynamodb:DescribeContinuousBackups",
#                 "dynamodb:DescribeExport",
#                 "s3:DeleteObject",
#                 "s3:CreateMultiRegionAccessPoint",
#                 "s3:GetBucketWebsite",
#                 "s3:GetMultiRegionAccessPoint",
#                 "s3:PutReplicationConfiguration",
#                 "s3:GetObjectAttributes",
#                 "s3:InitiateReplication",
#                 "s3:GetObjectLegalHold",
#                 "s3:GetBucketNotification",
#                 "s3:DescribeMultiRegionAccessPointOperation",
#                 "s3:GetReplicationConfiguration",
#                 "s3:PutObject",
#                 "s3:PutBucketNotification",
#                 "dynamodb:GetShardIterator",
#                 "dynamodb:DescribeReservedCapacity",
#                 "s3:PutBucketObjectLockConfiguration",
#                 "s3:CreateJob",
#                 "s3:GetStorageLensDashboard",
#                 "dynamodb:DescribeImport",
#                 "s3:GetLifecycleConfiguration",
#                 "s3:GetInventoryConfiguration",
#                 "s3:GetBucketTagging",
#                 "s3:GetAccessPointPolicyForObjectLambda",
#                 "dynamodb:ListTagsOfResource",
#                 "dynamodb:DescribeReservedCapacityOfferings",
#                 "s3:AbortMultipartUpload",
#                 "dynamodb:PartiQLSelect",
#                 "s3:UpdateJobPriority",
#                 "s3:DeleteBucket",
#                 "dynamodb:DescribeLimits",
#                 "s3:PutBucketVersioning",
#                 "s3:GetMultiRegionAccessPointPolicyStatus",
#                 "s3:PutIntelligentTieringConfiguration",
#                 "s3:PutMetricsConfiguration",
#                 "dynamodb:Query",
#                 "dynamodb:DescribeStream",
#                 "s3:GetBucketVersioning",
#                 "s3:GetAccessPointConfigurationForObjectLambda",
#                 "s3:PutInventoryConfiguration",
#                 "dynamodb:ListStreams",
#                 "s3:GetMultiRegionAccessPointRoutes",
#                 "s3:GetStorageLensConfiguration",
#                 "s3:DeleteStorageLensConfiguration",
#                 "s3:GetAccountPublicAccessBlock",
#                 "s3:PutBucketWebsite",
#                 "s3:PutBucketRequestPayment",
#                 "s3:PutObjectRetention",
#                 "s3:CreateAccessPointForObjectLambda",
#                 "dynamodb:DescribeGlobalTable",
#                 "s3:GetBucketCORS",
#                 "s3:GetObjectVersion",
#                 "s3:PutAnalyticsConfiguration",
#                 "s3:PutAccessPointConfigurationForObjectLambda",
#                 "s3:GetObjectVersionTagging",
#                 "s3:PutStorageLensConfiguration",
#                 "dynamodb:DescribeContributorInsights",
#                 "s3:CreateBucket",
#                 "s3:GetStorageLensConfigurationTagging",
#                 "s3:ReplicateObject",
#                 "s3:GetObjectAcl",
#                 "s3:GetBucketObjectLockConfiguration",
#                 "s3:DeleteBucketWebsite",
#                 "s3:GetIntelligentTieringConfiguration",
#                 "dynamodb:DescribeTable",
#                 "s3:GetObjectVersionAcl",
#                 "dynamodb:GetItem",
#                 "s3:GetBucketPolicyStatus",
#                 "dynamodb:BatchGetItem",
#                 "s3:GetObjectRetention",
#                 "s3:GetJobTagging",
#                 "dynamodb:Scan",
#                 "s3:PutObjectLegalHold",
#                 "s3:PutBucketCORS",
#                 "s3:GetObject",
#                 "s3:DescribeJob",
#                 "s3:PutBucketLogging",
#                 "s3:GetAnalyticsConfiguration",
#                 "s3:GetObjectVersionForReplication",
#                 "s3:GetAccessPointForObjectLambda",
#                 "dynamodb:DescribeBackup",
#                 "dynamodb:DescribeEndpoints",
#                 "dynamodb:GetRecords",
#                 "dynamodb:DescribeTableReplicaAutoScaling",
#                 "s3:CreateAccessPoint",
#                 "s3:GetAccessPoint",
#                 "s3:PutAccelerateConfiguration",
#                 "s3:SubmitMultiRegionAccessPointRoutes",
#                 "s3:DeleteObjectVersion",
#                 "s3:GetBucketLogging",
#                 "s3:RestoreObject",
#                 "s3:GetAccelerateConfiguration",
#                 "s3:GetObjectVersionAttributes",
#                 "s3:GetBucketPolicy",
#                 "s3:PutEncryptionConfiguration",
#                 "s3:GetEncryptionConfiguration",
#                 "s3:GetObjectVersionTorrent",
#                 "s3:GetBucketRequestPayment",
#                 "s3:GetAccessPointPolicyStatus",
#                 "s3:GetObjectTagging",
#                 "s3:GetMetricsConfiguration",
#                 "s3:GetBucketOwnershipControls",
#                 "dynamodb:DescribeKinesisStreamingDestination",
#                 "s3:GetBucketPublicAccessBlock",
#                 "s3:GetMultiRegionAccessPointPolicy",
#                 "dynamodb:ConditionCheckItem",
#                 "s3:GetAccessPointPolicyStatusForObjectLambda",
#                 "s3:PutBucketOwnershipControls",
#                 "s3:DeleteMultiRegionAccessPoint",
#                 "s3:UpdateJobStatus",
#                 "s3:GetBucketAcl",
#                 "dynamodb:DescribeTimeToLive",
#                 "s3:GetObjectTorrent",
#                 "dynamodb:DescribeGlobalTableSettings",
#                 "s3:GetBucketLocation",
#                 "s3:GetAccessPointPolicy",
#                 "s3:ReplicateDelete"
#             ],
#             "Resource": "*"  #need to be edit. insert only arn of specific s3 and dynamo db
#         }
#     ]
# })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

