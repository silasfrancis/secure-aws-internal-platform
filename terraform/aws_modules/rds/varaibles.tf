variable "tags" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "pg_instance_class" {
  type = string
}

variable "engine_version" {
  type = string
  default = "15"
}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}


variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "vpc_security_group_ids" {
  type = list(string)
}
