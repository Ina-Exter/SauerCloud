#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission2-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[AWS-Secgame] Generating ssh key for ec2"
aws --profile $SECGAME_USER_PROFILE ec2 create-key-pair --key-name AWS-secgame-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID --query 'KeyMaterial' --output text >> ressources/ssh_key
export sshkey=$(<ressources/ssh_key)
chmod 400 ressources/ssh_key

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
	mv ./mission3-$SECGAME_USER_ID ./trash/
	aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"

#Get the obtained keys.

#Return in mission dir
cd ../..

#Write briefing
echo "Agent, you are a godsent. Well done fetching those blueprints on that other server. The brass were delighted. You will find the usual pay on your usual account. \
We have another task for you. Our insider told us about a suspicious instance. Apparently, they intend to use it for a powerful wave of cyber-attacks. \
It was also brought to our attention that the instance contained sensitive data, but they have been redacted after some time. \
We have provided you with leaked AWS keys to their account, but they have little to no privilege. Your job is to access the instance, do some forensics on it in order to get the sensitive data out, then escalate your privileges and take it down.
We have great hopes for you.

AWS key =
AWS secret key =
" >> briefing.txt

echo "[AWS-Secgame] Mission 3 deployment complete. Mission folder is ./mission3-$SECGAME_USER_ID. Read the briefing.txt file to begin."

