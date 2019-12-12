#IAMR
resource "aws_iam_role" "AWS-secgame-mission5-role-ec2accessddb" {
    name               = "AWS-secgame-mission5-role-ec2accessddb-${var.id}"
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
resource "aws_iam_policy" "AWS-secgame-mission5-rolepolicy-ec2accessddb" {
  name        = "AWS-secgame-mission5-rolepolicy-ec2accessddb-${var.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#IAMPR
resource "aws_iam_role_policy_attachment" "AWS-secgame-mission5-rolepolicyattachment-ec2accessddb" {
  role       = "${aws_iam_role.AWS-secgame-mission5-role-ec2accessddb.name}"
  policy_arn = "${aws_iam_policy.AWS-secgame-mission5-rolepolicy-ec2accessddb.arn}"
}

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mission5-instanceprofile-ec2accessddb" {
  name = "AWS-secgame-mission5-instanceprofile-ec2accessddb-${var.id}"
  role = "${aws_iam_role.AWS-secgame-mission5-role-ec2accessddb.name}"
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
#Key pairs are handled with bash.

#EC2
#Dynamo-handler, server which has the rights to access the DDB
resource "aws_instance" "AWS-secgame-mission5-ec2-dynamo-handler" {
    ami                         = "ami-0b69ea66ff7391e80" #amazon linux 2
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile        = "${aws_iam_instance_profile.AWS-secgame-mission5-instanceprofile-ec2accessddb.name}"
    monitoring                  = false
    key_name                    = "AWS-secgame-mission5-keypair-ddb-handler-${var.id}"
    subnet_id                   = "${aws_subnet.AWS-secgame-mission5-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission5-sg.id}"]
    associate_public_ip_address = true #Switch to true for direct access to layer 3
    private_ip                  = "192.168.0.89"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<EOF
#!/bin/bash
sudo yum install ec2-instance-connect -y
echo "ec2-user:foobarbazevil" |sudo chpasswd
sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sudo service sshd restart
	    EOF
    tags = {
        Name = "AWS-secgame-mission5-ec2-dynamo-handler-${var.id}"
    }
}

#Honey-pot. Taking it down changes user permissions depending on lambda code. Literaly not supposed to be accessed.
resource "aws_instance" "AWS-secgame-mission5-ec2-hyper-critical-security-hypervisor" {
    ami                         = "ami-0b69ea66ff7391e80" #amazon linux 2
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    monitoring                  = false
    key_name                    = ""
    subnet_id                   = "${aws_subnet.AWS-secgame-mission5-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission5-sg.id}"]
    associate_public_ip_address = false
    private_ip                  = "192.168.0.121"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<EOF
#!/bin/bash
sudo route add 169.254.169.254 reject
sudo rm /etc/sudoers.d/90-cloud-init-users
	    EOF
    tags = {
        Name = "AWS-secgame-mission5-ec2-hyper-critical-security-hypervisor-${var.id}"
    }
}

#Mail server. Used for info gathering
resource "aws_instance" "AWS-secgame-mission5-ec2-mail-server" {
    ami                         = "ami-0b69ea66ff7391e80" #amazon linux 2
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    monitoring                  = false
    key_name                    = ""
    subnet_id                   = "${aws_subnet.AWS-secgame-mission5-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission5-sg.id}"]
    associate_public_ip_address = true
    private_ip                  = "192.168.0.37"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<EOF

	    EOF
    tags = {
		Feature = "NEW! Connect now with EC2-INSTANCE-CONNECT!"
        Name = "AWS-secgame-mission5-ec2-hyper-critical-security-hypervisor-${var.id}"
    }
}
