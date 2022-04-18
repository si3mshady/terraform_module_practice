# vpc main.tf
data "aws_availability_zones" "available" {}


resource "random_integer" "rand_int" {
  min = 1
  max = 10
}


resource "aws_vpc" "elliotts_aws_sandbox" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "elliott_arnold_vpc_sandbox-${random_integer.rand_int.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  cidr_block              = var.public_subnet[count.index]
  vpc_id                  = aws_vpc.elliotts_aws_sandbox.id
  map_public_ip_on_launch = true
  # availability_zone       = var.public_subnet_az[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "subnet-${var.public_subnet_az[count.index]}-${count.index}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}



resource "aws_subnet" "private_subnet" {

  count                   = var.private_subnet_count
  cidr_block              = var.private_subnet[count.index]
  vpc_id                  = aws_vpc.elliotts_aws_sandbox.id
  map_public_ip_on_launch = false
  # availability_zone       = var.private_subnet_az[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "subnet-${var.private_subnet_az[count.index]}-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.elliotts_aws_sandbox.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.elliotts_aws_sandbox.id

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}



resource "aws_default_route_table" "default_private_rt" {
  default_route_table_id = aws_vpc.elliotts_aws_sandbox.default_route_table_id

  tags = {
    Name = "private_route_table"
  }

}


resource "aws_security_group" "public_sg" {

  name   = "public_sg"
  vpc_id = aws_vpc.elliotts_aws_sandbox.id
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
