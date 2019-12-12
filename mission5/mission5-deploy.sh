#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission5-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[AWS-Secgame] Generating ssh key for dynamo handler"
aws --profile $SECGAME_USER_PROFILE ec2 create-key-pair --key-name AWS-secgame-mission5-keypair-ddb-handler-$SECGAME_USER_ID --query 'KeyMaterial' --output text >> resources/ssh_key.pem
if [[ ! $? == 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on operation. Abort."
	cd ..
	#No resource has been created, just delete the folder
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv mission5-$SECGAME_USER_ID ./trash/
	exit 2
fi
export sshkey=$(<resources/ssh_key.pem)
chmod 400 resources/ssh_key.pem

#Initialize code resources
cd resources/code
echo "[AWS-Secgame] Setting-up lambda functions' python code."
source create-lambda-change-group.sh
cd ../..

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
	echo "Abort requested. Destroying target folder."
	cd ../../..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv ./mission5-$SECGAME_USER_ID ./trash/
	aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission5-keypair-ddb-handler-$SECGAME_USER_ID
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
	mv ./mission5-$SECGAME_USER_ID ./trash/
	aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission5-keypair-ddb-handler-$SECGAME_USER_ID
	exit 2
fi

#Get the output
export DDB_HANDLER_INSTANCE_ID=$(terraform output ec2_ddb_instance_id)
export emetselch_key_id=$(terraform output emetselch_key)
export emetselch_secret_key=$(terraform output emetselch_secret_key)

#Prepare for lambda update
echo "[AWS-Secgame] Updating lambda code with correct instance ID."
cd ../code
source create-lambda-dump-logs.sh
zip lambda-dump-logs.zip lambda-dump-logs.py
aws --profile $SECGAME_USER_PROFILE lambda update-function-code --function-name AWS-secgame-mission5-lambda-logs-dump-$SECGAME_USER_ID --zip-file fileb://lambda-dump-logs.zip

#Return in mission dir
cd ../..

sleep 3

clear

#Write briefing
echo "$DDB_HANDLER_INSTANCE_ID \n $emetselch_key_id \n $emetselch_secret_key"  >> briefing.txt

echo "[AWS-Secgame] Mission 5 deployment complete. Mission folder is ./mission5-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd ..
cat mission5-$SECGAME_USER_ID/briefing.txt


