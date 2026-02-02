# alb
resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  security_group_id = aws_security_group.alb.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  depends_on = [ aws_security_group.alb ]
  tags = {
    Resource = "ALB"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_https" {
  security_group_id = aws_security_group.alb.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
    tags = {
    Resource = "ALB"
  }
  depends_on = [ aws_security_group.alb ]
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
    tags = {
    Resource = "ALB"
  }
  depends_on = [ aws_security_group.alb ]
}

# ec2
resource "aws_vpc_security_group_ingress_rule" "ec2_ingress_rule_api" {
    security_group_id = aws_security_group.ec2.id
    from_port = 8080
    to_port = 8080
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.alb.id
    tags = {
    Resource = "EC2"
  }
  depends_on = [ aws_security_group.ec2 ]
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ingress_rule_app" {
    security_group_id = aws_security_group.ec2.id
    from_port = 3000
    to_port = 3000
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.alb.id
    tags = {
    Resource = "EC2"
  }
  depends_on = [ aws_security_group.ec2 ]
}

resource "aws_vpc_security_group_egress_rule" "ec2_egress_rule" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  tags = {
    Resource = "EC2"
  }
  depends_on = [ aws_security_group.ec2 ]
}

# rds
resource "aws_vpc_security_group_ingress_rule" "rds_ingress_rule" {
    security_group_id = aws_security_group.rds.id
    from_port = 5432
    to_port = 5432
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.ec2.id
    tags = {
    Resource = "RDS"
    }
    depends_on = [ aws_security_group.rds ]
}

resource "aws_vpc_security_group_egress_rule" "rds_egress_rule" {
  security_group_id = aws_security_group.rds.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  tags = {
    Resource = "RDS"
    }
  depends_on = [ aws_security_group.rds ]
}
