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

resource "aws_iam_role" "AWS-secgame-mission2-ec2listrole" {
    name               = "AWS-secgame-mission2-ec2listrole-${var.id}"
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
resource "aws_iam_policy" "AWS-secgame-mission2-ec2listrolepolicy" {
  name        = "AWS-secgame-mission2-ec2listrolepolicy-${var.id}"

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

resource "aws_iam_policy" "AWS-secgame-mission2-ec2adminrolepolicy" {
  name        = "AWS-secgame-mission2-ec2adminrolepolicy-${var.id}"

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
resource "aws_iam_role_policy_attachment" "AWS-secgame-mission2-ec2adminrolepolicyattachment" {
  role       = "${aws_iam_role.AWS-secgame-mission2-ec2adminrole.name}"
  policy_arn = "${aws_iam_policy.AWS-secgame-mission2-ec2adminrolepolicy.arn}"
}

resource "aws_iam_role_policy_attachment" "AWS-secgame-mission2-ec2listrolepolicyattachment" {
  role       = "${aws_iam_role.AWS-secgame-mission2-ec2listrole.name}"
  policy_arn = "${aws_iam_policy.AWS-secgame-mission2-ec2listrolepolicy.arn}"
}

#IAMIP
resource "aws_iam_instance_profile" "AWS-secgame-mission2-ec2admininstanceprofile" {
  name = "AWS-secgame-mission2-ec2admininstanceprofile-${var.id}"
  role = "${aws_iam_role.AWS-secgame-mission2-ec2adminrole.name}"
}

resource "aws_iam_instance_profile" "AWS-secgame-mission2-ec2listinstanceprofile" {
  name = "AWS-secgame-mission2-ec2listinstanceprofile-${var.id}"
  role = "${aws_iam_role.AWS-secgame-mission2-ec2listrole.name}"
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
    iam_instance_profile = "${aws_iam_instance_profile.AWS-secgame-mission2-ec2admininstanceprofile.name}"
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
	
	PS: If you mess anything up I'll wring your neck." >> /home/ec2-user/bob_read_this.txt ;

	cat << "EOFF" > /home/ec2-user/ultra-sensitive-blueprints.txt
	          __..--''``---....___   _..._    __
	 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
	///_.-' _..--.'_    \                    `( ) ) // //
	/ (_..-' // (< _     ;_..__               ; `' / ///
	 / // // //  `-._,_)' // / ``--...____..-' /// / //
	
	      |\      _,,,---,,_
	ZZZzz /,`.-'`'    -.  ;-;;,_
	     |,4-  ) )-,_. ,\ (  `'-'
	    '---''(_/--'  `-'\_)  Felix Lee 
	                                            
	                                            
	                      /^--^\     /^--^\     /^--^\
	                      \____/     \____/     \____/
	                     /      \   /      \   /      \
	KAT                 |        | |        | |        |
	                     \__  __/   \__  __/   \__  __/
	|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|
	| | | | | | | | | | | | |\ \| | |/ /| | | | | | \ \ | | | | | | | | | | |
	########################/ /######\ \###########/ /#######################
	| | | | | | | | | | | | \/| | | | \/| | | | | |\/ | | | | | | | | | | | |
	|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
	
	
		M.					   .:M
		MMMM.					.:MMMM
		MMMMMMMM			     .:MMMMMMM
		:MMHHHMMMMHMM.	.:MMMMMMMMM:.	   .:MMHHMHMM:
		 :MMHHIIIHMMMM.:MMHHHHIIIHHMMMM. .:MMHIHIIHHM:
		  MMMHIIIIHHMMMIIHHMHHIIIIIHHMMMMMMHHHIIIIHHM:
		  :MMHIIIIIHMMMMMMMHHIIIIIIHHHMMMMMHHII:::IHM.
		   MH:I:::IHHMMMMMHHII:::IIHHMMMHHHMMM:I:IHMM
		   :MHI:HHIHMMHHIIHII::.::IIHMMHHIHHMMM::HMM:
		    MI::HHMMIIM:IIHII::..::HM:MHHII:::IHHMM:
		    MMMHII::..:::IHMMHHHMHHMMI:::...::IHM:
		    :MHHI::....::::HMMMMMMHHI::.. ..:::HM:
		     :MI:.:MH:.....:HMMMMHHMIHMMHHI:HH.:M
		     M:.I..MHHHHHMMMIHMMMMHMMHHHHHMMH:.:M.
		     M:.H..H  I:HM:MHMHI:IM:I:MM::  MMM:M:
		     :M:HM:.M I:MHMIIMMIIHM I:MM::.:MMI:M.
		     'M::MM:IMH:MMII MMHIMHI :M::IIHMM:MM
		      MH:HMMHIHMMMMMMHMMIMHIIHHHHIMMHHMM
		       MI:MMMMHI:::::IMM:MHI:::IMMMMHIM
			:IMHIHMMMMMM:MMMMMHHHHMMMHI:M
			 HI:IMIHMMMM:MMMMMMHHHMI:.:M	  .....
	     ............M::..:HMMMMIMHIIHMMMMHII:M:::''''
		 ....:::MHI:.:HMMMMMMMMHHHMHHI::M:::::::''''''
		''   ...:MHI:.::MMHHHMHMIHMMMMHH.MI..........
		   ''  ...MHI::.::MHHHHIHHMM:::IHM           '''
		      '  IMH.::..::HMMHMMMH::..:HM:
			:M:.H.IHMIIII::IIMHMMM:H.MH
			 IMMMH:HI:MMIMI:IHI:HIMIHM:
		       .MMI:.HIHMIMI:IHIHMMHIHI:MIM.
		      .MHI:::HHIIIIIHHI:IIII::::M:IM.
		     .MMHII:::IHIII::::::IIIIIIHMHIIM
		     MHHHI::.:IHHII:::.:::IIIIHMHIIHM:
		    MHHHII::..::MII::.. ..:IIIHHHII:IM.
		   .MHHII::....:MHII::.  .:IHHHI::IIHMM.
		   MMHHII::.....:IHMI:. ..:IHII::..:HHMM
		   MHHII:::......:IIHI...:IHI::.....::HM:
		  :MMH:::........ ...::..::....  ...:IHMM
		  IMHIII:::..........	  .........::IHMM.
		  :MHIII::::......	    .......::IHMM:
		   MHHIII::::...	     ......::IHMM:
		   IMHHIII:::...	     .....::IIHMM,
		   :MHHIII:::I:::...	 ....:::I:::IIHMM
		    MMHHIII::IHI:::...........:::IIH:IHMM
		    :MMHHII:IIHHI::::::.....:::::IH:IHMIM
		     MMMHHII:IIHHI:::::::::::::IHI:IIHM:M.
		     MMMHHIII::IHHII:::::::::IHI:IIIHMM:M:
		     :MMHHHIII::IIIHHII::::IHI..IIIHHM:MHM
		     :MMMHHII:..:::IHHMMHHHHI:IIIIHHMM:MIM
		     .MMMMHHII::.:IHHMM:::IIIIIIHHHMM:MI.M
		   .MMMMHHII::.:IHHMM:::IIIIIIHHHMM:MI.M
		 .MMMMHHMHHII:::IHHMM:::IIIIIHHHHMM:MI.IM.
		.MMHMMMHHHII::::IHHMM::I&&&IHHHHMM:MMH::IM.
	       .MMHHMHMHHII:::.::IHMM::IIIIHHHMMMM:MMH::IHM
	       :MHIIIHMMHHHII:::IIHMM::IIIHHMMMMM::MMMMHHHMM.
	       MMHI:IIHMMHHHI::::IHMM:IIIIHHHMMMM:MMMHI::IHMM.
	       MMH:::IHMMHHHHI:::IHMM:IIIHHHHMMMM:MMHI:.:IHHMM.
	       :MHI:::IHMHMHHII::IHMM:IIIHHHMMMMM:MHH::.::IHHM:
	       'MHHI::IHMMHMHHII:IHMM:IIHHHHMMMM:MMHI:...:IHHMM.
		:MHII:IIHMHIHHIIIIHMM:IIHHHHMMMM:MHHI:...:IIHMM:
		'MHIII:IHHMIHHHIIHHHMM:IHHHMMMMM:MHHI:..::IIHHM:
		 :MHHIIIHHMIIHHHIHHHMM:HHHHMMMMM:MHII::::IIIHHMM
		  MHHIIIIHMMIHHHIIHHMM:HHHHMMMM:MMHHIIHIIIIIHHMM.
		  'MHHIIIHHMIIHHIIIHMM:HHHMMMMH:MHHMHII:IIIHHHMM:
		   'MHHIIIHMMIHHHIHHMM:HHHMMMHH:MMIMMMHHHIIIHHMM:
		    'MHHIIHHMIHHHHHMMM:HHHMMMH:MIMMMMMMMMMMHIHHM:
		     'MHIIIHMMIHHHHHMM:HHHMMMH:IMMMMMHHIHHHMMHHM'
		      :MHHIIHMIHHHHHMM:HHHMMMM:MMHMMHIHMHI:IHHHM
		       MHHIIHM:HHHHHMM:HHHMMMM:MMMHIHHIHMM:HHIHM
			MHHIHM:IHHHHMM:HHHHMM:MMHMIIHMIMMMHMHIM:
			:MHIHMH:HHHHMM:HHHHMM:MMHIIHMIIHHMMHIHM:
			 MMHHMH:HHHHMM:HHHHMM:MHHIHMMIIIMMMIIHM'
			 'MMMMH:HHHHMM:HHHMM:MHHHIMMHIIII::IHM:
			  :MMHM:HHHHMM:HHHMM:MHIHIMMHHIIIIIHM:
			   MMMM:HHHHMM:HHHHM:MHHMIMMMHHHIHHM:MMMM.
			   :MMM:IHHHMM:HHHMM:MHHMIIMMMHHMM:MMMMMMM:
			   :MMM:IHHHM:HHHHMM:MMHHHIHHMMM:MMMMMMMMMM
			    MHM:IHHHM:HHHMMM:MMHHHHIIIMMIIMMMMMMMMM
			    MHM:HHHHM:HHHMMM:HMMHHHHHHHHHMMMMMMMMM:
			 .MI:MM:MHHMM:MHMMHMHHMMMMHHHHHHHMMMMMMMMM'
			:IM:MMIM:M:MM:MH:MM:MH:MMMMMHHHHHMMMMMMMM'
			:IM:M:IM:M:HM:IMIHM:IMI:MMMMMHHHMMMMMM:'
			 'M:MHM:HM:MN:HMIHM::M'   '::MMMMMMM:'
			    'M'HMM'M''M''HM'I'
	                                            
	/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\
	/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\/ᐠ｡‸｡ᐟ\
	/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\/ᐠ –ꞈ –ᐟ\
	
	"Well, you did type the command "cat" didn't you? :^)"
	
	EOFF 
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
    iam_instance_profile = "${aws_iam_instance_profile.AWS-secgame-mission2-ec2listinstanceprofile.name}"
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
	#sudo echo "eviluser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
	sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
	sudo service sshd restart
		
	echo "${var.sshprivatekey}" >> /home/ec2-user/AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-${var.id}.pem
	EOF
    tags = {
        Name = "AWS-secgame-mission2-ec2-Evil-bastion-for-evil-access-${var.id}"
    }
}

