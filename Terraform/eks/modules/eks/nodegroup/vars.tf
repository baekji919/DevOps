variable "cluster_name" {
  type = string
}

variable "ng_name" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "desired_size" {
  type = number
  default = 1
}

variable "max_size" {
  type = number
  default = 2
}

variable "min_size" {
  type = number
  default = 1
}