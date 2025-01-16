resource "aws_apigatewayv2_vpc_link" "example" {
  name =  var.vpc_name
  security_group_ids = var.vpc_security_group_id
  subnet_ids = var.subnet_id
}