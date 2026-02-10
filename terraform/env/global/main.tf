terraform {
  
    backend "s3" {
    bucket = "silas-global-silas-global"
    key = "global/terraform.tfstate"
    region = "us-east-2"
    use_lockfile = true
    encrypt = true
    
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  environment = "global"
  tag = "silas-global"
}

module "acm" {
  source = "../../aws_modules/acm"
}

module "iam" {
  source = "../../aws_modules/iam"
  tags = local.tag
}


module "s3" {
    source = "../../aws_modules/s3"
  
  bucket_name = "${local.tag}-silas-${local.environment}"
  bucket_key = "${local.environment}/terraform.tfstate"
  bucket_rule_id = "${local.tag}${local.environment}"
  bucket_rule_status = "Enabled"
  bucket_exp_days = 60
  versioning_config_status = "Enabled"
  s3_server_sse_algorithm = "AES256"
}

module "dynamodb" {
  source = "../../aws_modules/dynamodb"

  table_name = "${local.tag}db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "object_key"
}