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
resource "aws_iam_policy" "AWS-secgame-mission4-ec2-policy" {
  name = "AWS-secgame-mission4-ec2-policy-${var.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:ListUsers",
        "iam:PutUserPolicy",
        "s3:ListAllMyBuckets"
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
  role       = aws_iam_role.AWS-secgame-mission4-role-ec2.name
  policy_arn = aws_iam_policy.AWS-secgame-mission4-ec2-policy.arn
}

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mission4-ec2-instanceprofile" {
  name = "AWS-secgame-mission4-ec2-instanceprofile-${var.id}"
  role = aws_iam_role.AWS-secgame-mission4-role-ec2.name
}

#SG
resource "aws_security_group" "AWS-secgame-mission4-sg-evilcorp-allow" { #Standard access SG
  name        = "AWS-secgame-mission4-sg-evilcorp-allow-${var.id}"
  description = "Allow whitelisted IP in, Evil Manager insisted on being able to connect from his mistress' home..."
  vpc_id      = aws_vpc.AWS-secgame-mission4-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.ip}/32"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = []
    self            = true
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Create 2nd SG
resource "aws_security_group" "AWS-secgame-mission4-sg-evilcorp-filtered" { #Standard access SG
  name        = "AWS-secgame-mission4-sg-evilcorp-filtered-${var.id}"
  description = "Filtered ips out of the Evilcorp pool with this evil security group"
  vpc_id      = aws_vpc.AWS-secgame-mission4-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}/32"]
    self        = true
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.AWS-secgame-mission4-sg-evilcorp-allow.id]
    self            = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#KP
#Key pair is handled with bash AWS-secgame-mission4-keypair-Evilcorp-Evilkeypair-var.id


#EC2
resource "aws_instance" "AWS-secgame-mission4-ec2-filtered" {
  ami                         = "ami-0b69ea66ff7391e80"
  availability_zone           = "us-east-1a"
  ebs_optimized               = false
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.AWS-secgame-mission4-ec2-instanceprofile.name
  monitoring                  = false
  key_name                    = "AWS-secgame-mission4-keypair-Evilcorp-Evilkeypair-${var.id}"
  subnet_id                   = aws_subnet.AWS-secgame-mission4-subnet.id
  vpc_security_group_ids      = [aws_security_group.AWS-secgame-mission4-sg-evilcorp-filtered.id]
  associate_public_ip_address = true
  private_ip                  = "192.168.0.219"
  source_dest_check           = true
  disable_api_termination     = false

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  user_data = <<-EOF
#!/bin/bash
touch /home/ec2-user/tamere
sudo yum install httpd -y
echo 'bla' > /home/ec2-user/tamere
sudo echo "<!DOCTYPE html>" > /var/www/html/index.html
sudo echo "<html>" >> /var/www/html/index.html
sudo echo "<head>" >> /var/www/html/index.html
sudo echo "<title>Evilcorp Evilpage</title>" >> /var/www/html/index.html
sudo echo "</head>" >> /var/www/html/index.html
sudo echo "<body>" >> /var/www/html/index.html
sudo echo "<h1>Your IP does not belong to the Evilcorp IP pool. You are filtered!</h1>" >> /var/www/html/index.html
sudo echo "<d>JV Hacker Protection Services</d>" >> /var/www/html/index.html
sudo echo "</body>" >> /var/www/html/index.html
sudo echo "</html>" >> /var/www/html/index.html
echo 'wololo' >> /home/ec2-user/tamere
sudo systemctl restart httpd
echo 'aaaaaaaaaaaaaa' >> /home/ec2-user/tamere
EOF
  tags = {
    Name = "AWS-secgame-mission4-ec2-filtered-${var.id}"
  }
}



