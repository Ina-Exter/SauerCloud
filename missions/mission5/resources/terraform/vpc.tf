#VPC
resource "aws_vpc" "SauerCloud-mission5-vpc" {
  cidr_block           = "192.168.0.0/24"
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "SauerCloud-mission5-vpc-${var.id}"
  }
}

#IGW
resource "aws_internet_gateway" "SauerCloud-mission5-igw" {
  vpc_id = aws_vpc.SauerCloud-mission5-vpc.id

  tags = {
    Name = "SauerCloud-mission5-igw-${var.id}"
  }
}

#Subnets
resource "aws_subnet" "SauerCloud-mission5-subnet" {
  vpc_id                  = aws_vpc.SauerCloud-mission5-vpc.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "SauerCloud-mission5-subnet-${var.id}"
  }
}

#RTB
resource "aws_route_table" "SauerCloud-mission5-routing-table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.SauerCloud-mission5-igw.id
  }
  vpc_id = aws_vpc.SauerCloud-mission5-vpc.id
  tags = {
    Name = "SauerCloud-mission5-routing-table-${var.id}"
  }
}

#RTA
resource "aws_route_table_association" "SauerCloud-mission5-rta" {
  subnet_id      = aws_subnet.SauerCloud-mission5-subnet.id
  route_table_id = aws_route_table.SauerCloud-mission5-routing-table.id
}

#NACL
resource "aws_network_acl" "SauerCloud-mission5-acl" {
  vpc_id     = aws_vpc.SauerCloud-mission5-vpc.id
  subnet_ids = [aws_subnet.SauerCloud-mission5-subnet.id]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "SauerCloud-mission5-acl-${var.id}"
  }
}
