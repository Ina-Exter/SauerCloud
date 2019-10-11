#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission2-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[AWS-Secgame] Generating ssh key for ec2"
aws --profile $SECGAME_USER_PROFILE ec2 create-key-pair --key-name AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID --query 'KeyMaterial' --output text >> ressources/ssh_key.pem
export sshkey=$(<ressources/ssh_key.pem)
chmod 400 ressources/ssh_key.pem

#Initialize terraform
cd ressources/terraform
echo "[AWS-Secgame] Initializing terraform."
terraform init

#Pass the required variables (profile, region?, id, key) to terraform and plan
terraform plan -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"

#IF AND ONLY IF user consents, deploy
echo "[AWS-Secgame] Is this setup acceptable? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "Abort requested. Destroying target folder."
	cd ../../..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv ./mission2-$SECGAME_USER_ID ./trash/
	aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"

#Get the bastion's IP address as output
export bastion_ip=$(terraform output bastion_ip_addr)

#Return in mission dir
cd ../..

#Write briefing
echo "Wonderful job on that Evilcorp bucket, agent. I am glad you are on our side. I have further news for you. \
Word has it that Evilcorp started building a proof-of-concept data maintainment structure on AWS. \
It uses a bastion for easy and \"secure\" access, but they enabled SSH login with a password under some pressure from management. \
They also neglected to protect the instance against SSH bruteforce, so our servers in Russia and China were able to find it. \
Log in as eviluser on $bastion_ip, with password ConquerTheWorld. There might be other instances on the network, accessible from the bastion. \
With hope, you will be able to find the blueprints for their latest evil project on one such server. Good luck, agent..."  >> briefing.txt

echo "[AWS-Secgame] Mission 2 deployment complete. Mission folder is ./mission2-$SECGAME_USER_ID. Read the briefing.txt file to begin."

