terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

data "aws_iam_instance_profile" "global_iam_instance_profile" {
  name = "silas-global-ec2-profile"
}

resource "aws_instance" "ec2_instance_1" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id_1
  vpc_security_group_ids  = var.ec2_security_group_id
  iam_instance_profile = data.aws_iam_instance_profile.global_iam_instance_profile.name  
  associate_public_ip_address = false
  tags = {
    Name = "${var.tags}-instance1"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id_2
  vpc_security_group_ids  = var.ec2_security_group_id
  iam_instance_profile = data.aws_iam_instance_profile.global_iam_instance_profile.name    
  associate_public_ip_address = false
  tags = {
    Name = "${var.tags}-instance2"
  }
}

resource "aws_instance" "wireguard_server" {
  ami = var.ami
  instance_type = var.wireguard_instance_type
  subnet_id = var.public_subnet_id_1
  vpc_security_group_ids  = var.wireguard_security_group_id
  iam_instance_profile = data.aws_iam_instance_profile.global_iam_instance_profile.name    
  associate_public_ip_address = true
  tags = {
    Name = "${var.tags}-wireguard-server"
  }
  
}