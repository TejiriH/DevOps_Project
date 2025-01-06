variable "database_user" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_pwd" {
  type = string
}

variable "first_3_subnets" {
  type = list(string)
}

variable "private_security_id" {
  type =  string
}

variable "db_host" {
  type =  string
}

variable "efs_id" {
  type =  string
}

variable "efs_mount_command" {
  type =  string
}

variable "vpc_id" {
  type = string
}

variable "public_security_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}