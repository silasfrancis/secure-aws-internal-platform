terraform {
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
