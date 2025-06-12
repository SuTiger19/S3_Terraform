# https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/resources/s3_bucket_versioning



data "aws_partition" "current" {}

data "aws_region" "current" {}
resource "aws_s3_bucket" "mybucketdst" {
  bucket = "gateway-datasecure-inc-crr--222398712"
  provider      = aws.dst
  tags = {
    Name        = "Terraform"
    Environment = "test"
    Created     = "Sudeep"

  }
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "versioning_dst" {
  provider      = aws.dst
  bucket = aws_s3_bucket.mybucketdst.id
  versioning_configuration {
    status = "Enabled"
  }
}


data "aws_iam_role" "LabRole" {
  name = "labRole"
}


resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.src
  bucket   = aws_s3_bucket.mybucket.id
  role     = data.aws_iam_role.LabRole.arn
   depends_on = [
    aws_s3_bucket_versioning.versioning_dst
  ]

  rule {
    id     = "cross-region-replication"
    status = "Enabled"

    filter {
      prefix = "" 
    }

    destination {
      bucket        = aws_s3_bucket.mybucketdst.arn
      storage_class = "STANDARD"
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }
}



resource "aws_cloudtrail" "s3_bucketloging" {

  name                          = "example"
  s3_bucket_name                = aws_s3_bucket.example.id
  s3_key_prefix                 = "s3_logging"
  include_global_service_events = false

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
            values = ["${ aws_s3_bucket.mybucket.arn}/"]
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket        = "sudeepcloudtrail"
  force_destroy = true
}

data "aws_iam_policy_document" "example" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.example.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.example.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/example"]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.example.json
}

