#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SAUERCLOUD_USER_PROFILE"
echo "[SauerCloud] Session ID: $SAUERCLOUD_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission2-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[SauerCloud] Generating ssh key for ec2"
if ! aws --profile "$SAUERCLOUD_USER_PROFILE" ec2 create-key-pair --key-name "SauerCloud-mission2-keypair-Evilcorp-Evilkeypair-$SAUERCLOUD_USER_ID" --query 'KeyMaterial' --output text >> resources/ssh_key.pem
then
	echo "[SauerCloud] Non-zero return code on operation. Abort."
	cd .. || exit
	#No resource has been created, just delete the folder
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv "mission2-$SAUERCLOUD_USER_ID" ./trash/
	exit 2
fi
sshkey=$(<resources/ssh_key.pem)
chmod 400 resources/ssh_key.pem

#Initialize terraform
cd resources/terraform || exit
echo "[SauerCloud] Initializing terraform."
terraform init

#Pass the required variables (profile, region?, id, key) to terraform and plan
terraform plan -var="profile=$SAUERCLOUD_USER_PROFILE" -var="id=$SAUERCLOUD_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"

#IF AND ONLY IF user consents, deploy
echo "[SauerCloud] Is this setup acceptable? (yes/no)"
echo "[SauerCloud] Only \"yes\" will be accepted as confirmation."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[SauerCloud] Abort requested. Destroying target folder."
	cd ../../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission2-$SAUERCLOUD_USER_ID" ./trash/
	aws --profile "$SAUERCLOUD_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission2-keypair-Evilcorp-Evilkeypair-$SAUERCLOUD_USER_ID"
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
#check terraform apply's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform apply -auto-approve -var="profile=$SAUERCLOUD_USER_PROFILE" -var="id=$SAUERCLOUD_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
then
	echo "[SauerCloud] Non-zero return code on terraform apply. Rolling back."
	terraform destroy -auto-approve -var="profile=$SAUERCLOUD_USER_PROFILE" -var="id=$SAUERCLOUD_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
	cd ../../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission2-$SAUERCLOUD_USER_ID" ./trash/
	aws --profile "$SAUERCLOUD_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission2-keypair-Evilcorp-Evilkeypair-$SAUERCLOUD_USER_ID"
	exit 2
fi

#Get the bastion's IP address as output
bastion_ip=$(terraform output bastion_ip_addr)

#Return in mission dir
cd ../.. || exit

sleep 3

clear

#Write briefing
echo "Wonderful job on that Evilcorp bucket, agent. I am glad you are on our side. I have further news for you. \
Word has it that Evilcorp started building a proof-of-concept data maintainment structure on AWS. \
It uses a bastion for easy and \"secure\" access, but they enabled SSH login with a password under some pressure from management. \
They also neglected to protect the instance against SSH bruteforce, so our servers in Russia and China were able to find it. \
Log in as eviluser on $bastion_ip, with password ConquerTheWorld. There might be other instances on the network, accessible from the bastion. \
With hope, you will be able to find the blueprints for their latest evil project on one such server. Good luck, agent..."  >> briefing.txt

echo "[SauerCloud] Mission 2 deployment complete. Mission folder is ./mission2-$SAUERCLOUD_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd ..
cat "mission2-$SAUERCLOUD_USER_ID/briefing.txt"

