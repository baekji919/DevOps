variable "vpc_id" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "igw_id" {
  type = string
}
variable "sub_cidr" {
  type = list(string)
}

variable "az" {
  type = list(string)
}

variable "vpc_peering_id" {
  type = string
}