output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "vpc_default_sg_id" {
  value = aws_default_security_group.main.id
}