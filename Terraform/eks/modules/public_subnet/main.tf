resource "aws_subnet" "public" {
  count = 3
  vpc_id = var.vpc_id
  cidr_block = var.sub_cidr[count.index]
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-pub-subnet-${count.index+1}",
    "kubernetes.io/role/elb" = "1"

  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.vpc_name}-pub-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 3

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "new_public_to_default" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "x.x.x.x/16"
  vpc_peering_connection_id = var.vpc_peering_id
}