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
