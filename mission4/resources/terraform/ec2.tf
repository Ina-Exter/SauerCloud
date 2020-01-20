#IAMR
resource "aws_iam_role" "AWS-secgame-mission4-ec2" {
    name               = "AWS-secgame-mission4-ec2-${var.id}"
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
resource "aws_iam_policy" "AWS-secgame-mission4-ec2" {
  name        = "AWS-secgame-mission4-${var.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "#TODO"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#IAMPR
resource "aws_iam_role_policy_attachment" "AWS-secgame-mission4-ec2rolepolicyattachment" {
  role       = "#TODO"
  policy_arn = "#TODO"
}

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mission4-ec2-instanceprofile" {
  name = "AWS-secgame-mission4-ec2-instanceprofile-${var.id}"
  role = "#TODO
}

#SG
resource "aws_security_group" "AWS-secgame-mission4-sg" { #Standard access SG
    name        = "AWS-secgame-mission4-sg-${var.id}"
    description = "Allow whitelisted IP in, and other instances from same SG"
    vpc_id      = "${aws_vpc.AWS-secgame-mission4-vpc.id}"

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

#Create 2nd SG

#KP
#Key pair is handled with bash.

#EC2
resource "aws_instance" "AWS-secgame-mission4-ec2-" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile = "#TODO"
    monitoring                  = false
    key_name                    = "#TODO"
    subnet_id                   = "${aws_subnet.AWS-secgame-mission4-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission4-sg.id}"]
    associate_public_ip_address = false
    private_ip                  = "192.168.0.219"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }

    tags = {
        Name = "AWS-secgame-mission4-ec2--${var.id}"
    }
}

resource "aws_instance" "AWS-secgame-mission4-ec2-" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile = "#TODO"
    monitoring                  = false
    key_name                    = "#TODO"
    subnet_id                   = "${aws_subnet.AWS-secgame-mission4-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission4-sg.id}"]
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
        Name = "AWS-secgame-mission4-ec2--${var.id}"
    }
}

