resource "aws_vpc_peering_connection" "main" {
  peer_owner_id = var.account_id
  peer_vpc_id = var.default_vpc_id
  vpc_id = var.vpc_id
  auto_accept = true

  tags = {
    Name = "${var.vpc_name}-default-peer"
  }
}

resource "aws_route" "default_to_new" {
  route_table_id = "rtb-id"
  destination_cidr_block = "x.x.x.x/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id

}