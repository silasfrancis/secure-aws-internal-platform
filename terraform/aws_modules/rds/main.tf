terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

resource "aws_db_subnet_group" "private_subnets" {
  name = "${var.tags}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
      Name = "${var.tags}-rds-subnet-group"
    }
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.tags}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.pg_instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = aws_db_subnet_group.private_subnets.name
  multi_az = true
  publicly_accessible = false
  storage_encrypted = true


  tags = {
    Name = "${var.tags}-postgres"
  }
}
