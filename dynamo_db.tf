# much configuration needed. do i need to insert the attribute the keys and values here?
resource "aws_dynamodb_table" "commit_dynamo_db_table" {
  name           = "GameScores"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}