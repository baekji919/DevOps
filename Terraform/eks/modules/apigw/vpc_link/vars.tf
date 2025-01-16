variable "vpc_name" {
  type = string
}

variable "vpc_security_group_id" {
  type = list(string)
}

variable "subnet_id" {
  type = list(string)
}