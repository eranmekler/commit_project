resource "aws_dynamodb_table" "commit_dynamo_db_table" {
  name           = "commit_db"
  hash_key       = "username"  # partition key
  range_key      = "timestamp" # sort key
  write_capacity = 20
  read_capacity  = 20

   attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = {
    Name        = "commit"
    Environment = "production"
  }
}