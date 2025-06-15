output s3_bucket {
  value       = aws_s3_bucket.s3_wesbite.id
  description = "S3BucketName"

}

output s3_bucket_website {
  value = aws_s3_bucket_website_configuration.example.website_domain
}