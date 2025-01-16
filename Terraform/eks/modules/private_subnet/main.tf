resource "aws_subnet" "private" {
  count = 3
  vpc_id = var.vpc_id
  cidr_block = var.sub_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "${var.vpc_name}-pri-subnet-${count.index +1}",
    "kubernetes.io/role/internal-elb" = "1"

  }
}

resource "aws_route_table" "private" {
  count = 3
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.ngw_id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index +1}"
  }
}

resource "aws_route_table_association" "private" {
  count = 3

  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "new_private_to_default" {
  count = 3
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = "x.x.x.x/16"
  vpc_peering_connection_id = var.vpc_peering_id
}