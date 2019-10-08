#IAMR
resource "aws_iam_role" "AWS-secgame-mission2-ec2adminrole" {
    name               = "AWS-secgame-mission2-ec2adminrole-${var.id}"
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

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mision2-ec2instanceprofile" {
  name = "AWS-secgame-mision2-ec2instanceprofile-${var.id}"
  role = "${aws_iam_role.AWS-secgame-mission2-ec2adminrole.name}"
}

#SG
resource "aws_security_group" "AWS-secgame-mission2-sg" {
    name        = "AWS-secgame-mission2-sg-${var.id}"
    description = "Allow whitelisted IP in, and other instances from same SG"
    vpc_id      = "${aws_vpc.AWS-secgame-mission2-vpc.id}"

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
resource "aws_instance" "AWS-secgame-mission2-ec2-Evil-server-for-evil-data" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.AWS-secgame-mision2-ec2instanceprofile.name}"
    monitoring                  = false
    key_name                    = "AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-${var.id}"
    subnet_id                   = "${aws_subnet.AWS-secgame-mission2-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission2-sg.id}"]
    associate_public_ip_address = false
    private_ip                  = "192.168.0.219"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
	#!/bin/bash
	echo "Bob, come on. Stop logging here. This server is hyper critical and has admin rights. You may SSH here only from the premises but still, don't go around fooling with what you don't understand.
	Yours sincerly,
	
	-IT
	
	PS: If you mess anything up I'll wring your neck." >> /home/ec2-user/bob_read_this.txt
	echo "
	          __..--''``---....___   _..._    __
	 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
	///_.-' _..--.'_    \                    `( ) ) // //
	/ (_..-' // (< _     ;_..__               ; `' / ///
	 / // // //  `-._,_)' // / ``--...____..-' /// / //
	
	           .                .                    
	           :"-.          .-";                    
	           |:`.`.__..__.'.';|                    
	           || :-"      "-; ||                    
	           :;              :;                    
	           /  .==.    .==.  \                    
	          :      _.--._      ;                   
	          ; .--.' `--' `.--. :                   
	         :   __;`      ':__   ;                  
	         ;  '  '-._:;_.-'  '  :                  
	         '.       `--'       .'                  
	          ."-._          _.-".                   
	        .'     ""------""     `.                 
	       /`-                    -'\                
	      /`-                      -'\               
	     :`-   .'              `.   -';              
	     ;    /                  \    :              
	    :    :                    ;    ;             
	    ;    ;                    :    :             
	    ':_:.'                    '.;_;'             
	       :_                      _;                
	       ; "-._                -" :`-.     _.._    
	       :_          ()          _;   "--::__. `.  
	        \"-                  -"/`._           :  
	       .-"-.                 -"-.  ""--..____.'  
	      /         .__  __.         \               
	     : / ,       / "" \       . \ ;              
	      "-:___..--"      "--..___;-"               
	                                            
	/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\
	/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\
	/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\
	" >> /home/ec2-user/ultra-sensitive-data.txt
	EOF
    tags = {
        Name = "AWS-secgame-mission2-ec2-Evil-server-for-evil-data-${var.id}"
    }
}

resource "aws_instance" "AWS-secgame-mission2-ec2-Evil-bastion-for-evil-access" {
    ami                         = "ami-0b69ea66ff7391e80"
    availability_zone           = "us-east-1a"
    ebs_optimized               = false
    instance_type               = "t2.micro"
    monitoring                  = false
    key_name                    = "AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-${var.id}"
    subnet_id                   = "${aws_subnet.AWS-secgame-mission2-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.AWS-secgame-mission2-sg.id}"]
    associate_public_ip_address = true
    private_ip                  = "192.168.0.188"
    source_dest_check           = true

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
	#!/bin/bash
	sudo adduser eviluser
	echo "eviluser:ConquerTheWorld" |sudo chpasswd
	sudo usermod -aG sudo eviluser
	sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
	sudo service sshd restart
		
	echo "${var.sshprivatekey}" >> /home/ec2-user/AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-${var.id}.pem
	EOF
    tags = {
        Name = "AWS-secgame-mission2-ec2-Evil-bastion-for-evil-access-${var.id}"
    }
}

