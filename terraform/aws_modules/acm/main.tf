terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

resource "aws_acm_certificate" "lefrancis_cert" {
  domain_name               = "lefrancis.org"
  subject_alternative_names = [
    "app.lefrancis.org",
    "api.lefrancis.org"
  ]
  validation_method = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}
