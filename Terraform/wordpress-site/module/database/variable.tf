variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_pwd" {
  type = string
}