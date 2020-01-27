#SG
resource "aws_security_group" "AWS-secgame-mission3-sg" {
    name        = "AWS-secgame-mission3-sg-${var.id}"
    description = "Allow whitelisted IP in"
    vpc_id      = aws_vpc.AWS-secgame-mission3-vpc.id

    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["${var.ip}/32"]
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
resource "aws_instance" "AWS-secgame-mission3-ec2-completely-safe-critical-server" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile        = aws_iam_instance_profile.AWS-secgame-mission3-ec2listinstanceprofile.name
    monitoring                  = false
    key_name                    = "AWS-secgame-mission3-keypair-Evilcorp-Evilkeypair-${var.id}"
    subnet_id                   = aws_subnet.AWS-secgame-mission3-subnet.id
    vpc_security_group_ids      = [aws_security_group.AWS-secgame-mission3-sg.id]
    associate_public_ip_address = true
    private_ip                  = "192.168.0.144"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    tags = {
        Name = "AWS-secgame-mission3-ec2-completely-safe-critical-server-${var.id}"
    }
}

