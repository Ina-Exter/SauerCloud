#IAMR
resource "aws_iam_role" "AWS-secgame-mission4-role-ec2" {
    name               = "AWS-secgame-mission4-role-ec2-${var.id}"
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
        "iam:AttachGroupPolicy"
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
  role       = "aws_iam_role.AWS-secgame-mission4-role-ec2.name"
  policy_arn = "aws_iam_policy.AWS-secgame-mission4-ec2.arn"
}

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mission4-ec2-instanceprofile" {
  name = "AWS-secgame-mission4-ec2-instanceprofile-${var.id}"
  role = "aws_iam_role.AWS-secgame-mission4-role-ec2.name"
}

#SG
resource "aws_security_group" "AWS-secgame-mission4-allow" { #Standard access SG
    name        = "AWS-secgame-mission4-allow-${var.id}"
    description = "Allow whitelisted IP in, and other instances from same SG"
    vpc_id      = "aws_vpc.AWS-secgame-mission4-vpc.id"

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
resource "aws_security_group" "AWS-secgame-mission4-filtered" { #Standard access SG
    name        = "AWS-secgame-mission4-filtered-${var.id}"
    description = "filtered ip with secruty group"
    vpc_id      = "aws_vpc.AWS-secgame-mission4-vpc.id"

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = []
        self            = true
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = []
        cidr_blocks     = ["${var.ip}/32"]
        self            = true
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = ["AWS-secgame-mission4-allow-${var.id}"]
        self            = true
    }

}

#KP
#Key pair is handled with bash key_step1


#EC2
resource "aws_instance" "AWS-secgame-mission4-ec2-filtered" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile        = ""
    monitoring                  = false
    key_name                    = "key_step1"
    subnet_id                   = "aws_subnet.AWS-secgame-mission4-subnet.id"
    vpc_security_group_ids      = ["aws_security_group.AWS-secgame-mission4-filtered.id"]
    associate_public_ip_address = true
    private_ip                  = "192.168.0.219"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
    yum update
    yum install httpd 
    cat /var/www/index.html <<EOFF
    <!DOCTYPE html>
    <html>
    <head>
    <title>Page Title</title>
    </head>
    <body>

    <h1>Your are Filtered</h1>
    <d>try to hack me</d>
    </body>
    </html>
    EOFF 
    systemctl restart httpd
    EOF

    tags = {
        Name = "AWS-secgame-mission4-ec2-filtered--${var.id}"
    }
}



