#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo $SECGAME_USER_PROFILE
echo $SECGAME_USER_ID
echo $USER_IP

#ALWAYS assume that this script will run in the mission folder mission2-user_id

#A ssh private key should also be generated and passed as parameter.
export sshkey=$(aws --profile $SECGAME_USER_PROFILE ec2 create-key-pair --key-name AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID --query 'KeyMaterial' --output text)

#Consider saving the private key juuuuuuuuuust in case.
echo AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID >> ressources/ssh_key
chmod 400 ressources/ssh_key

#Initialize terraform
cd ressources/terraform
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
Log in as eviluser on $bastion_ip, with password ConquerTheWorld, and see what you can find."  >> briefing.txt

echo "Mission 2 deployment complete. Read the briefing.txt file to begin."

