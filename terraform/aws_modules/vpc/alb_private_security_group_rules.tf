resource "aws_vpc_security_group_ingress_rule" "alb_private_ingress_http" {
  security_group_id = aws_security_group.alb_private.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.wireguard.id
    tags = {
    Resource = "ALB Private"
  }
  depends_on = [ aws_security_group.alb_private ]
}

resource "aws_vpc_security_group_ingress_rule" "alb_private_ingress_https" {
  security_group_id = aws_security_group.alb_private.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.wireguard.id
    tags = {
    Resource = "ALB Private"
  }
  depends_on = [ aws_security_group.alb_private ]
}

resource "aws_vpc_security_group_egress_rule" "alb_private_egress" {
  security_group_id = aws_security_group.alb_private.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
    tags = {
    Resource = "ALB Private"
  }
  depends_on = [ aws_security_group.alb_private ]
}
