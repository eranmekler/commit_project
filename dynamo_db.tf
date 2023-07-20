resource "aws_dynamodb_table" "commit_dynamo_db_table" {
  name           = "commit_db"
  hash_key       = "Username"  # partition key
  range_key      = "Timestamp" # sort key
  write_capacity = 20
  read_capacity  = 20

   attribute {
    name = "Username"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "S"
  }

  tags = {
    Name        = "commit"
    Environment = "production"
  }
}