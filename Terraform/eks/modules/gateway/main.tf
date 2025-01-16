resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = var.eip_name
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id = var.pub_subnet_id

  tags = {
    Name = var.ngw_name
  }
}