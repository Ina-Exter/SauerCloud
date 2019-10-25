#VPC
resource "aws_vpc" "AWS-secgame-mission3-vpc" {
    cidr_block           = "192.168.0.0/24"
    enable_dns_hostnames = false
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        Name = "AWS-secgame-mission3-vpc-${var.id}"
    }
}

#IGW
resource "aws_internet_gateway" "AWS-secgame-mission3-igw" {
    vpc_id = "${aws_vpc.AWS-secgame-mission3-vpc.id}"

    tags = {
        Name = "AWS-secgame-mission3-igw-${var.id}"
    }
}

#Subnets
resource "aws_subnet" "AWS-secgame-mission3-subnet" {
    vpc_id                  = "${aws_vpc.AWS-secgame-mission3-vpc.id}"
    cidr_block              = "192.168.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "AWS-secgame-mission3-subnet-${var.id}"
    }
}

#RTB
resource "aws_route_table" "AWS-secgame-mission3-routing-table" {
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.AWS-secgame-mission3-igw.id}"
  }
  vpc_id = "${aws_vpc.AWS-secgame-mission3-vpc.id}"
  tags = {
      Name = "AWS-secgame-mission3-routing-table-${var.id}"
  }
}

#RTA
resource "aws_route_table_association" "AWS-secgame-mission3-rta" {
  subnet_id = "${aws_subnet.AWS-secgame-mission3-subnet.id}"
  route_table_id = "${aws_route_table.AWS-secgame-mission3-routing-table.id}"
}

#NACL
resource "aws_network_acl" "AWS-secgame-mission3-acl" {
    vpc_id     = "${aws_vpc.AWS-secgame-mission3-vpc.id}"
    subnet_ids = ["${aws_subnet.AWS-secgame-mission3-subnet.id}"]

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
        Name = "AWS-secgame-mission3-acl-${var.id}"
    }
}