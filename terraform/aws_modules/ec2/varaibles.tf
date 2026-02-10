variable "tags" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_id_1" {
  type = string
}

variable "private_subnet_id_2" {
  type = string
}

variable "ec2_security_group_id" {
  type = list(string)
}

variable "wireguard_instance_type" {
  type = string
}

variable "public_subnet_id_1" {
  type = string
}

variable "wireguard_security_group_id" {
  type = list(string) 
}