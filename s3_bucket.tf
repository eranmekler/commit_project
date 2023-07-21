# resource "aws_s3_bucket" "my_bucket" {
#   bucket = "Yuval_Eran_Commit"
# #  acl    = "private" //been deprecated?

#   tags = {
#     Name        = "Yuval_Eran_Commit"
#     Environment = "Production"
#   }
# }

# #do i need to insert this block for the file creation?

# #resource "aws_s3_bucket_object" "my_file" {
# #  bucket       = aws_s3_bucket.my_bucket.id
# #  key          = "path/to/my/file.txt"
# #  source       = "path/to/local/file.txt"
# #  content_type = "text/plain"
# #}

