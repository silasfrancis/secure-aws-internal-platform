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
  environment = "dev"
  tag = "silas-dev"
}

module "secrets_manager" {
  source = "../../aws_modules/secrets_manager"
}

module "vpc" {
  source = "../../aws_modules/vpc"
  tags = local.tag
}

module "ec2" {
  source = "../../aws_modules/ec2"

  tags = local.tag
  ami = "ami-06e3c045d79fd65d9"
  instance_type =  "c7i-flex.large"  #"m7i-flex.large"
  vpc_id = module.vpc.vpc_id
  private_subnet_id_1 = module.vpc.subnets["private_subnet_1"]
  private_subnet_id_2 = module.vpc.subnets["private_subnet_2"]
  ec2_security_group_id = module.vpc.security_group["ec2"]
}

module "rds" {
  source = "../../aws_modules/rds"

  tags = local.tag
  private_subnet_ids = [
                        module.vpc.subnets["private_subnet_1"], 
                        module.vpc.subnets["private_subnet_2"]
                      ]
  pg_instance_class = "db.t4g.micro"
  engine_version = "15"
  allocated_storage = 20
  storage_type = "gp2"
  db_name = "${local.tag}-db"
  db_username = module.secrets_manager.db_secrets["db_username"]
  db_password = module.secrets_manager.db_secrets["db_password"]
  vpc_security_group_ids = [module.vpc.security_group["rds"]]
}

module "alb" {
  source = "../../aws_modules/alb"

  tags = local.tag
  public_subnets = [
                        module.vpc.subnets["public_subnet_1"], 
                        module.vpc.subnets["public_subnet_2"]
                      ]
  security_groups = [module.vpc.security_group["alb"]]
  vpc_id = module.vpc.vpc_id
  ec2_instances_ids = {
    instance1 = module.ec2.ec2_instances["instance1"],
    instance2 = module.ec2.ec2_instances["instance2"]
  }
}