output s3_bucket {
  value       = aws_s3_bucket.mybucket.id
  sensitive   = true
  description = "S3BucketName"

}
