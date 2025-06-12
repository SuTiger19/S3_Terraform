terraform {
  backend "s3" {
    bucket = "terraform-sudeep-2025-1239812"
    key    = "module1/terraform.tfstate"
    region = "us-east-1"
    use_lockfile  = true
  }
}
