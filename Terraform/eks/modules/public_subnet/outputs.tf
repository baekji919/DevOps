output "pub_subnet_id" {
  value = aws_subnet.public[0].id
}

output "rt_id" {
  value = aws_route_table.public.id
}