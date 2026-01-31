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
  certificate_arn = aws_acm_certificate.lefrancis_org.arn

  default_action {
    type             = "forward"
    target_group_arn = data.aws_acm_certificate.lefrancis_org.arn
  }

  depends_on = [ data.aws_acm_certificate.lefrancis_org ]
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