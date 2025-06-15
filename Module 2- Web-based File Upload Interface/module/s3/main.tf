# https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/resources/s3_bucket_versioning


data "aws_iam_role" "LabRole" {
  name = "labRole"
}



resource "aws_s3_bucket" "s3_wesbite" {
 bucket = "terraform-sudeep-2025-sudeepsaurabh-webp-1" 
 force_destroy = true
}


resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.s3_wesbite.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "publiceaccess" {
  bucket = aws_s3_bucket.s3_wesbite.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.publiceaccess,
  ]

  bucket = aws_s3_bucket.s3_wesbite.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.s3_wesbite.id
  key    = "index_to_s3.html"
  source = "index_to_s3.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.s3_wesbite.id
  key    = "styles.css"
  source = "styles.css"
}

resource "aws_s3_object" "js" {
  bucket = aws_s3_bucket.s3_wesbite.id
  key    = "script_to_s3.js"
  source = "script_to_s3.js"
  content_type = "text/html"
}



resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3_wesbite.id

  index_document {
    suffix = "index_to_s3.html"
  }


}

/*

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.s3_wesbite.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
   "Principal": "*",
      "Action": [ "s3:GetObject" ],
      "Resource": [
        "${aws_s3_bucket.s3_wesbite.arn}",
        "${aws_s3_bucket.s3_wesbite.arn}/*"
      ]
    }
  ]
}
EOF
}
*/


data "aws_iam_policy_document" "https_only_policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
             "s3:DeleteObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject",
            "s3:PutObjectAcl"
    ]

    resources = [
      "${aws_s3_bucket.s3_wesbite.arn}/*",
       "${aws_s3_bucket.s3_wesbite.arn}"

    ]
  }
  

}
resource "aws_s3_bucket_policy" "denyhttp" {
  bucket = aws_s3_bucket.s3_wesbite.id
  policy = data.aws_iam_policy_document.https_only_policy.json
}





resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.s3_wesbite.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = [ "HEAD",
            "GET",
            "PUT",
            "POST",
            "DELETE",
            "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000


  }




}