resource "aws_s3_bucket_ownership_controls" "trails" {
  bucket = aws_s3_bucket.trails.id

  rule {
    object_ownership = "ObjectWriter"
  }
}
