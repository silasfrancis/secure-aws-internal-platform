variable "tags" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ec2_instances_ids" {
  type = map(string)
}

variable "acm_certifcate_arn" {
  type = string
}