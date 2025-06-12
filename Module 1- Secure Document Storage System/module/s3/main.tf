/*

Task 1: Secure S3 Bucket 
• Create a bucket named: gateway-datasecure-inc-docs-XXXX in us-east-1
• Enable SSE-KMS encryption using a KMS key (with key rotation)

DONE


Task 2: Bucket Policy
• Enforce HTTPS-only access via a bucket policy
• Grant permissions to the pre-provided LabRole




Task 3: Lifecycle Management
• Add rules to:
o Transition data to S3 Standard-IA after 30 days
o Transition to S3 Glacier after 90 days
Done


Task 4: Disaster Recovery
• Enable versioning - Done
• Create a replica bucket named gateway-datasecure-inc-crr-XXXX in us-west-2
• Configure cross-region replication using the ReplicationRole
Task 5: Monitoring and Audit
• Enable AWS CloudTrail logging for all S3 operations on the primary bucket
*/

#S3


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      configuration_aliases = [ aws.src, aws.dst ]
    }
  }
}


resource "aws_s3_bucket" "mybucket" {
  bucket = "gateway-datasecure-inc-docs-12398712"
  provider      = aws.src
  tags = {
    Name        = "Terraform"
    Environment = "test"
    Created     = "Sudeep"
  }
  
}


resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  provider      = aws.src
  bucket = aws_s3_bucket.mybucket.id

  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "transition-to-S3 Glacier"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}



# https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/resources/s3_bucket_versioning



resource "aws_s3_bucket_versioning" "versioning_example" {
  provider      = aws.src
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}



#S3 ServerKMS
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.mybucket.id
  provider      = aws.src
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key_s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_caller_identity" "current" {}


#KMS



resource "aws_kms_key" "key_s3" {
  description             = "S3 Key"
  enable_key_rotation     = var.enable_key_rotation
  rotation_period_in_days = var.rotation_period_kms
  deletion_window_in_days = var.deletion_window
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy



data "aws_iam_policy_document" "https_only_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Deny"

    actions = [
      "s3:*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values    = ["false"]
    }

    resources = [
      "${aws_s3_bucket.mybucket.arn}/*",
    ]
  }
  
    statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.LabRole.arn]
    }

    effect = "Allow"

    actions = [
      "s3:*"
    ]


    resources = [
      "${aws_s3_bucket.mybucket.arn}/*",
    ]
  }
}
resource "aws_s3_bucket_policy" "denyhttp" {
  bucket = aws_s3_bucket.mybucket.id
  policy = data.aws_iam_policy_document.https_only_policy.json
}





