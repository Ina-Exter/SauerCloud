#IAMR
resource "aws_iam_role" "AWS-secgame-mission5-ec2adminrole" {
    name               = "AWS-secgame-mission5-ec2adminrole-${var.id}"
    path               = "/"
    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
         {
             "Effect": "Allow",
             "Principal": {
             "Service": "ec2.amazonaws.com"
             },
             "Action": "sts:AssumeRole"
         }
    ]
}
POLICY
}

resource "aws_iam_role" "AWS-secgame-mission5-ec2listrole" {
    name               = "AWS-secgame-mission5-ec2listrole-${var.id}"
    path               = "/"
    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
         {
             "Effect": "Allow",
             "Principal": {
             "Service": "ec2.amazonaws.com"
             },
             "Action": "sts:AssumeRole"
         }
    ]
}
POLICY
}

#IAMP
resource "aws_iam_policy" "AWS-secgame-mission5-ec2listrolepolicy" {
    name        = "AWS-secgame-mission5-ec2listrolepolicy-${var.id}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
         {
             "Action": [
             "ec2:Describe*"
             ],
             "Effect": "Allow",
             "Resource": "*"
         }
    ]
}
EOF
}

resource "aws_iam_policy" "AWS-secgame-mission5-ec2adminrolepolicy" {
    name        = "AWS-secgame-mission5-ec2adminrolepolicy-${var.id}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
            "*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

#IAMPR
resource "aws_iam_role_policy_attachment" "AWS-secgame-mission5-ec2adminrolepolicyattachment" {
    role       = "${aws_iam_role.AWS-secgame-mission5-ec2adminrole.name}"
    policy_arn = "${aws_iam_policy.AWS-secgame-mission5-ec2adminrolepolicy.arn}"
}

resource "aws_iam_role_policy_attachment" "AWS-secgame-mission5-ec2listrolepolicyattachment" {
    role       = "${aws_iam_role.AWS-secgame-mission5-ec2listrole.name}"
    policy_arn = "${aws_iam_policy.AWS-secgame-mission5-ec2listrolepolicy.arn}"
}

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mission5-ec2admininstanceprofile" {
    name = "AWS-secgame-mission5-ec2admininstanceprofile-${var.id}"
    role = "${aws_iam_role.AWS-secgame-mission5-ec2adminrole.name}"
}

resource "aws_iam_instance_profile" "AWS-secgame-mission5-ec2listinstanceprofile" {
    name = "AWS-secgame-mission5-ec2listinstanceprofile-${var.id}"
    role = "${aws_iam_role.AWS-secgame-mission5-ec2listrole.name}"
}

#SG
resource "aws_security_group" "AWS-secgame-mission5-sg" {
    name        = "AWS-secgame-mission5-sg-${var.id}"
    description = "Allow whitelisted IP in, and other instances from same SG"
    vpc_id      = "${aws_vpc.AWS-secgame-mission5-vpc.id}"

    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["${var.ip}/32"]
    }

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = []
        self            = true
    }


    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

}

#KP
#Key pair is handled with bash.

#EC2
resource "aws_instance" "AWS-secgame-mission5-ec2-rds-handler" {
    ami                         = "ami-04b9e92b5572fa0d1" #ubuntu server 18.04
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    monitoring                  = false
    key_name                    = ""
    subnet_id                   = "${aws_subnet.AWS-secgame-mission5-subnet-rds.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission5-sg-rds.id}"]
    associate_public_ip_address = false
    private_ip                  = "192.168.1.111"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
        sudo apt-get update
        sudo apt-get install default-mysql-client -y
        mysql --host=${aws_db_instance.AWS-secgame-mission5-evil-password-database.endpoint} --user=admin --password=foobarbaz --execute="CREATE DATABASE evilcorpPasswordDatabase;"
        mysql --host=${aws_db_instance.AWS-secgame-mission5-evil-password-database.endpoint} --user=admin --password=foobarbaz evilcorpPasswordDatabase --execute="CREATE TABLE AWSkeys ( accessKey VARCHAR(100) PRIMARY KEY, secretAccessKey VARCHAR(100) NOT NULL ); INSERT INTO AWSkeys (accessKey, secretAccessKey) VALUES ('${aws_iam_access_key.AWS-secgame-mission5-iam-admin-hades-keys.id}', '${aws_iam_access_key.AWS-secgame-mission5-iam-admin-hades-keys.secret}');"
        sudo route add 169.254.169.254 reject
        sudo rm /etc/sudoers.d/90-cloud-init-users
	    EOF
    tags = {
        Name = "AWS-secgame-mission5-ec2-rds-handler-${var.id}"
    }
}

resource "aws_instance" "AWS-secgame-mission5-ec2-Evil-bastion-for-evil-access" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.AWS-secgame-mission5-ec2listinstanceprofile.name}"
    monitoring                  = false
    key_name                    = "AWS-secgame-mission5-keypair-Evilcorp-Evilkeypair-${var.id}"
    subnet_id                   = "${aws_subnet.AWS-secgame-mission5-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission5-sg.id}"]
    associate_public_ip_address = true
    private_ip                  = "192.168.0.188"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
	
	EOF
    tags = {
        Name = "AWS-secgame-mission5-ec2-Evil-bastion-for-evil-access-${var.id}"
    }
}

