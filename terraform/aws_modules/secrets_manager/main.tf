terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

data "aws_secretsmanager_secret" "secret" {
  name = "basic_secrets"
}

data "aws_secretsmanager_secret_version" "db_secrets" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}