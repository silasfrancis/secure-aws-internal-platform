terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

resource "aws_instance" "ec2_instance_1" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id_1
  vpc_security_group_ids  = var.ec2_security_group_id
  iam_instance_profile = var.iam_instance_profile   
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
  iam_instance_profile = var.iam_instance_profile   
  associate_public_ip_address = false
  tags = {
    Name = "${var.tags}-instance2"
  }
}

