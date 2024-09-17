data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "tfpoc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "tfpoc_vpc"
  }
}

resource "aws_internet_gateway" "tfpoc_igw" {
  vpc_id = aws_vpc.tfpoc.id

  tags = {
    Name = "tfpoc_igw"
  }
}

resource "aws_subnet" "tfpoc_public_subnet" {
  vpc_id                = aws_vpc.tfpoc.id
  cidr_block            = var.publicSubnet_cidr[count.index]
  availability_zone     = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  count                 = 2

   tags = {
    Name                = "tfpoc_public_subnet.${count.index}"
  }
  
}

resource "aws_security_group" "instance_sg" {
  name        = "allow_http_traffic"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.tfpoc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = [var.internet_cidr]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}
