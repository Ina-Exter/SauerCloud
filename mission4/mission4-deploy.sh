#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission2-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[AWS-Secgame] Generating ssh key for ec2"
aws --profile $SECGAME_USER_PROFILE ec2 create-key-pair --key-name AWS-secgame-mission4-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID --query 'KeyMaterial' --output text >> resources/ssh_key.pem
if [[ ! $? == 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on operation. Abort."
	cd ..
	#No resource has been created, just delete the folder
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv mission4-$SECGAME_USER_ID ./trash/
	exit 2
fi
export sshkey=$(<resources/ssh_key.pem)
chmod 400 resources/ssh_key.pem

#Initialize terraform
cd resources/terraform
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
	echo "[AWS-Secgame] Abort requested. Destroying target folder."
	cd ../../..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv ./mission4-$SECGAME_USER_ID ./trash/
	aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission4-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"

#check terraform apply's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if [[ $? != 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on terraform apply. Rolling back."
	terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
	cd ../../..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv ./mission4-$SECGAME_USER_ID ./trash/
	aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission4-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID
	exit 2
fi

#Get the bastion's IP address as output
export juan_key=$(terraform output juan_key)
export juan_secret_key=$(terraform output juan_secret_key)

#Return in mission dir
cd ../..

cp resources/ssh_key.pem . 

sleep 3

#uncomment in prod
clear

#Write briefing
echo "Excellent work, agent. I am in awe at the size of these cats. Absolute units.
Still, there's a new bogey on our radar. We've found another Evilcorp bucket, but it seems they learned their lession (who'd have thought), it is not public. An instance also exists, but you will find it most... curious. They have actually learned how to block traffic. We obtained the ssh key for this instance, which corresponds to the AWS keypair of the instance, but the port 22 is apparently inaccessible. 
We have found some AWS keys for your recon operation, perhaps you can find a way to circumvent the blocking? 
The keypair you need is in mission4-$SECGAME_USER_ID/ssh_key.pem
juan_access_key = $juan_key
juan_secret_access_key = $juan_secret_key"  >> briefing.txt

echo "[AWS-Secgame] Mission 4 deployment complete. Mission folder is ./mission4-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd ..
cat mission4-$SECGAME_USER_ID/briefing.txt

