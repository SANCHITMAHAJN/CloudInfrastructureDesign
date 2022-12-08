resource "aws_s3_bucket" "bucket1" {
  bucket = "xyzcorpbbucket1"

  tags = {
    Name        = "Bucket"
  }
}

resource "aws_s3_bucket_acl" "s3acl" {
  bucket = aws_s3_bucket.bucket1.id
  acl    = "private"
}