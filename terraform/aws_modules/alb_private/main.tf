terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

resource "aws_lb" "app_private_lb" {
  name = "${var.tags}-alb"
  load_balancer_type = "application"
  internal = true
  subnets = var.private_subnets
  security_groups = var.security_groups
}
