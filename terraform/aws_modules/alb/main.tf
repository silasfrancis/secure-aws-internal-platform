terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

resource "aws_lb" "app_lb" {
  name = "${var.tags}-alb"
  load_balancer_type = "application"
  internal = false
  subnets = var.public_subnets
  security_groups = var.security_groups

}

resource "aws_lb_target_group" "frontend_target_group" {
  name     = "${var.tags}-tg-frontend"
  port     = 3000
  protocol = "HTTP"
  vpc_id  = var.vpc_id

  health_check {
    path = "/"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "api_target_group" {
  name     = "${var.tags}-tg-api"
  port     = 8080
  protocol = "HTTP"
  vpc_id  = var.vpc_id

  health_check {
    path = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}

resource "aws_lb_listener_rule" "api_lb_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  condition {
    host_header {
      values = ["api.lefrancis.org"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }
}


resource "aws_lb_target_group_attachment" "frontend_target_group_attachment" {
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
  for_each = {
    for k, v in var.ec2_instances_ids:
    k => v
  }
  target_id = each.value
  port = 3000
}

resource "aws_lb_target_group_attachment" "api_target_group_attachment" {
  target_group_arn = aws_lb_target_group.api_target_group.arn
  for_each = {
    for k, v in var.ec2_instances_ids:
    k => v
  }
  target_id = each.value
  port = 8080
}