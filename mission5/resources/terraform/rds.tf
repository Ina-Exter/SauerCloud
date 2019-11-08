#RDS
resource "aws_db_instance" "AWS-secgame-mission5-evil-password-database" {
    identifier                = "aws-secgame-mission5-evil-password-database-${var.id}"
    allocated_storage         = 20
    storage_type              = "gp2"
    engine                    = "mysql"
    engine_version            = "5.7.22"
    instance_class            = "db.t2.micro"
    name                      = "evilcorpPasswordDatabase"
    username                  = "admin"
    password                  = "foobarbaz"
    port                      = 3306
    publicly_accessible       = false
    availability_zone         = "us-east-1d"
    vpc_security_group_ids    = ["${aws_security_group.AWS-secgame-mission5-sg-rds.id}"]
    db_subnet_group_name      = "${aws_db_subnet_group.AWS-secgame-mission5-subnet-group-rds.id}"
    parameter_group_name      = "default.mysql5.7"
    multi_az                  = false
    backup_retention_period   = 7
    backup_window             = "10:16-10:46"
    maintenance_window        = "tue:08:32-tue:09:02"
    skip_final_snapshot       = true
}

#RDS Subnet
resource "aws_subnet" "AWS-secgame-mission5-subnet-rds-1" {
    vpc_id                  = "${aws_vpc.AWS-secgame-mission5-vpc.id}"
    cidr_block              = "192.168.1.0/24"
    availability_zone       = "us-east-1d"
    map_public_ip_on_launch = false

    tags = {
        Name = "AWS-secgame-mission5-subnet-rds-1-${var.id}"
    }
}
resource "aws_subnet" "AWS-secgame-mission5-subnet-rds-2" {
    vpc_id                  = "${aws_vpc.AWS-secgame-mission5-vpc.id}"
    cidr_block              = "192.168.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false

    tags = {
        Name = "AWS-secgame-mission5-subnet-rds-2-${var.id}"
    }
}

#RDS Subnet GROUP (needs 2)
resource "aws_db_subnet_group" "AWS-secgame-mission5-subnet-group-rds" {
  name       = "aws-secgame-mission5-subnet-group-rds-${var.id}"
  subnet_ids = ["${aws_subnet.AWS-secgame-mission5-subnet-rds-1.id}", "${aws_subnet.AWS-secgame-mission5-subnet-rds-2.id}"]

  tags = {
    Name = "AWS-secgame-mission5-subnet-group-rds-${var.id}"
  }
}

#RDS SG
resource "aws_security_group" "AWS-secgame-mission5-sg-rds" {
    name        = "AWS-secgame-mission5-sg-rds-${var.id}"
    description = "Allow whitelisted IP in, and other instances from same SG"
    vpc_id      = "${aws_vpc.AWS-secgame-mission5-vpc.id}"

    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        security_groups = ["${aws_security_group.AWS-secgame-mission5-sg.id}"]
        self            = true
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

}
