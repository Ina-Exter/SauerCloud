#RDS
resource "aws_db_instance" "AWS-secgame-mission5-evil-password-database" {
    identifier                = "AWS-secgame-mission5-evil-password-database"
    allocated_storage         = 20
    storage_type              = "gp2"
    engine                    = "mysql"
    engine_version            = "5.7.22"
    instance_class            = "db.t2.micro"
    name                      = "evilcorp-password-database"
    username                  = "admin"
    password                  = "foobarbaz"
    port                      = 3306
    publicly_accessible       = false
    availability_zone         = "us-east-1d"
    security_group_names      = []
    vpc_security_group_ids    = ["${aws_security_group.AWS-secgame-mission5-sg-rds}"]
    db_subnet_group_name      = "${aws_subnet.AWS-secgame-mission5-subnet-rds.id}
    parameter_group_name      = "default.mysql5.7"
    multi_az                  = false
    backup_retention_period   = 7
    backup_window             = "10:16-10:46"
    maintenance_window        = "tue:08:32-tue:09:02"
    skip_final_snapshot       = true
}

#RDS Subnet
resource "aws_subnet" "AWS-secgame-mission5-subnet-rds" {
    vpc_id                  = "${aws_vpc.AWS-secgame-mission5-vpc.id}"
    cidr_block              = "192.168.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "AWS-secgame-mission5-subnet-rds-${var.id}"
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
        security_groups = [${aws_security_group.AWS-secgame-mission5-sg.id}]
        self            = true
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

}
