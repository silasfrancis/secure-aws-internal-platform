resource "aws_security_group" "wireguard" {
    name = "wireguard-security_group"
    vpc_id = aws_vpc.main_vpc.id
    tags = {
    Name = "${var.tags}-security_group-wireguard"      
    }
  depends_on = [ aws_vpc.main_vpc ]
}

resource "aws_security_group" "alb" {
    name = "alb-security_group"
    vpc_id = aws_vpc.main_vpc.id
    tags = {
    Name = "${var.tags}-security_group-alb"      
    }
  depends_on = [ aws_vpc.main_vpc ]
}

resource "aws_security_group" "alb_private" {
    name = "alb-private-security_group"
    vpc_id = aws_vpc.main_vpc.id
    tags = {
    Name = "${var.tags}-security_group-alb-private"      
    }
  depends_on = [ aws_vpc.main_vpc ]
  
}

resource "aws_security_group" "ec2" {
    name = "ec2-security_group"
    vpc_id = aws_vpc.main_vpc.id
    tags = {
    Name = "${var.tags}-security_group-ec2"      
    }
  depends_on = [ aws_vpc.main_vpc ]
}

resource "aws_security_group" "rds" {
    name = "rds-security_group"
    vpc_id = aws_vpc.main_vpc.id
    tags = {
    Name = "${var.tags}-security_group-rds"      
    }
  depends_on = [ aws_vpc.main_vpc ]
}