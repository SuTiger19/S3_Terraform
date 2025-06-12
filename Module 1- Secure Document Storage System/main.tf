module "s3" {
    source = "./module/s3"
    providers = {
        aws.src = aws.src
        aws.dst = aws.dst
    }
    enable_key_rotation     = true
    rotation_period_kms = "90"
    deletion_window = "7"
}

provider "aws" {
  alias  = "src"
  region = "us-east-1" 
}

provider "aws" {
  alias  = "dst"
  region = "us-west-2"
}