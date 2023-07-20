#resource "aws_s3_bucket" "commit_bucket" {
#  bucket_prefix = "yuval-eran-commit"
##  acl    = "private" //been deprecated?
#
#  tags = {
#    Name        = "Yuval_Eran_Commit"
#    Environment = "Production"
#  }
#}
#
## resource is used to set the AWS account-level settings to restrict public access to
## S3 buckets within the account. It does not associate with a specific bucket.
## Instead, once these settings are configured for the account,
## they will apply to all S3 buckets within that account.
#
#resource "aws_s3_account_public_access_block" "commit_bucket_block" {
#  block_public_acls   = true
#  block_public_policy = true
#}
#
#
#
