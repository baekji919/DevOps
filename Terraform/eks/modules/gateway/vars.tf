variable "vpc_id" {
  type = string
}

variable "igw_name" {
  type = string
  default = "test-igw"
}

variable "eip_name" {
  type = string
  default = "test-eip"
}

variable "ngw_name" {
  type = string
  default = "test-ngw"
}

variable "pub_subnet_id" {
  type = string
}