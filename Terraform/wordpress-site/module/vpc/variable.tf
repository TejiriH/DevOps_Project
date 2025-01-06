variable "vpc_id" {
    description = "value"
    type        = string
    default     = " "
}

variable "vpc_cidr_block" {
    description = "vpc cidr_block range"
    type        = string
    default     = " "
}

variable "public_subnet_cidrs" {
    description = "value"
    type        = list(string)
}

variable "private_subnet_cidrs" {
    description = "value"
    type        = list(string)
}

variable "public_subnet_ids" {
    description = "value"
    type        = list(string)
    
}

variable "private_subnet_ids" {
    description = "value"
    type        = list(string)
    
}