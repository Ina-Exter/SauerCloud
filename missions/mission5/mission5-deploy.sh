#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SECGAME_USER_PROFILE"
echo "[SauerCloud] Session ID: $SECGAME_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission5-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[SauerCloud] Generating ssh key for dynamo handler"
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 create-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID" --query 'KeyMaterial' --output text >> resources/ssh_ddb_key.pem
then
	echo "[SauerCloud] Non-zero return code on operation. Abort."
	cd .. || exit
	#No resource has been created, just delete the folder
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv "mission5-$SECGAME_USER_ID" ./trash/
	exit 2
fi
sshddbkey=$(<resources/ssh_ddb_key.pem)
chmod 400 resources/ssh_ddb_key.pem
echo "[SauerCloud] Generating service ssh key"
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 create-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID" --query 'KeyMaterial' --output text >> resources/ssh_service_key.pem
then
	echo "[SauerCloud] Non-zero return code on operation. Abort."
	cd .. || exit
	#Destroy previous key
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv "mission5-$SECGAME_USER_ID" ./trash/
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
	exit 2
fi
sshservicekey=$(<resources/ssh_service_key.pem)
chmod 400 resources/ssh_service_key.pem

#Initialize code resources
cd resources/code || exit
echo "[SauerCloud] Setting-up lambda functions' python code."
# shellcheck disable=SC1091
source create-lambda-change-group.sh
cd ../.. || exit

#Get account id
accountID=$(aws --profile "$SECGAME_USER_PROFILE" sts get-caller-identity --query Account)

#Initialize terraform
cd resources/terraform || exit
echo "[SauerCloud] Initializing terraform."
terraform init

#Pass the required variables (profile, region?, id, key) to terraform and plan
terraform plan -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey" -var="accountid=$accountID"

#IF AND ONLY IF user consents, deploy
echo "[SauerCloud] Is this setup acceptable? (yes/no)"
echo "[SauerCloud] Only \"yes\" will be accepted as confirmation."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "Abort requested. Destroying target folder."
	cd ../../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission5-$SECGAME_USER_ID" ./trash/
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID"
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
#check terraform apply's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey" -var="accountid=$accountID"
then
	echo "[SauerCloud] Non-zero return code on terraform apply. Rolling back."
	terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey"
	cd ../../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission5-$SECGAME_USER_ID" ./trash/
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID"
	exit 2
fi

#Get the output
DDB_HANDLER_INSTANCE_ID=$(terraform output ec2_ddb_instance_id)
export DDB_HANDLER_INSTANCE_ID
MAIL_SERVER_INSTANCE_ID=$(terraform output ec2_mailserver_instance_id)
MAIL_SERVER_IP=$(terraform output ec2_mailserver_public_ip)
emmyselly_key_id=$(terraform output emmyselly_key)
emmyselly_secret_key=$(terraform output emmyselly_secret_key)
solus_key_id=$(terraform output solus_key)
solus_secret_key=$(terraform output solus_secret_key)

#Prepare for lambda update
echo "[SauerCloud] Updating lambda code with correct instance ID."
cd ../code || exit
# shellcheck disable=SC1091
source create-lambda-dump-logs.sh
zip lambda-dump-logs.zip lambda-dump-logs.py > /dev/null 2>&1
if ! aws --profile "$SECGAME_USER_PROFILE" lambda update-function-code --function-name "SauerCloud-mission5-lambda-logs-dump-$SECGAME_USER_ID" --zip-file fileb://lambda-dump-logs.zip > /dev/null 2>&1
then
	echo "[SauerCloud] Non-zero return code on lambda code update. Retrying."
	if ! aws --profile "$SECGAME_USER_PROFILE" lambda update-function-code --function-name "SauerCloud-mission5-lambda-logs-dump-$SECGAME_USER_ID" --zip-file fileb://lambda-dump-logs.zip > /dev/null 2>&1
	then
		echo "[SauerCloud] Non-zero return code on lambda code update (second attempt). Abort."
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
				mkdir trash
		fi
		mv "./mission5-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID"
		exit 2
	fi
fi

#mail server setup
echo "[SauerCloud] Mail server setup now running."
sleep 8
ssh-keygen -t rsa -f mailserver_temporary_key.pem -q -N ""
echo "[SauerCloud] Key Generated."
aws --profile "$SECGAME_USER_PROFILE" ec2-instance-connect send-ssh-public-key --availability-zone us-east-1a --instance-os-user ec2-user --instance-id "$MAIL_SERVER_INSTANCE_ID" --ssh-public-key file://mailserver_temporary_key.pem.pub > /dev/null 2>&1
echo "[SauerCloud] Copying file."
if ! scp -i "mailserver_temporary_key.pem" -o "StrictHostKeyChecking=no" make_mail_system.sh "ec2-user@$MAIL_SERVER_IP:/home/ec2-user/" > /dev/null 2>&1
then
	echo "[SauerCloud] Cannot send data to mail server. Retrying."
	if ! scp -i "mailserver_temporary_key.pem" -o "StrictHostKeyChecking=no" make_mail_system.sh "ec2-user@$MAIL_SERVER_IP:/home/ec2-user/" > /dev/null 2>&1
	then
		echo "[SauerCloud] Cannot send data to mail server (second attempt). Check your internet connection. Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
  		      	mkdir trash
		fi
		mv "./mission5-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID"
		exit 2
	fi
fi

echo "[SauerCloud] Script startup."
aws --profile "$SECGAME_USER_PROFILE" ec2-instance-connect send-ssh-public-key --availability-zone us-east-1a --instance-os-user ec2-user --instance-id "$MAIL_SERVER_INSTANCE_ID" --ssh-public-key file://mailserver_temporary_key.pem.pub > /dev/null 2>&1
if ! ssh -i "mailserver_temporary_key.pem" -o "StrictHostKeyChecking=no" "ec2-user@$MAIL_SERVER_IP" 'chmod u+x make_mail_system.sh; sudo bash -c "./make_mail_system.sh"; exit' > /dev/null 2>&1
then
	echo "[SauerCloud] Cannot send data to mail server. Retrying."
	if ! ssh -i "mailserver_temporary_key.pem" -o "StrictHostKeyChecking=no" "ec2-user@$MAIL_SERVER_IP" 'chmod u+x make_mail_system.sh; sudo bash -c "./make_mail_system.sh"; exit' > /dev/null 2>&1
	then
		echo "[SauerCloud] Cannot send data to mail server (second attempt). Check your internet connection. Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
  		      	mkdir trash
		fi
		mv "./mission5-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID"
		exit 2
	fi
fi

#Add emmyselly keys to bucket
cd .. || exit
touch aws_key_reminder.txt
echo "emmyselly_aws_key = $emmyselly_key_id" > aws_key_reminder.txt
echo "emmyselly_private_key = $emmyselly_secret_key" >> aws_key_reminder.txt
if ! aws --profile "$SECGAME_USER_PROFILE" s3 cp aws_key_reminder.txt "s3://sauercloud-mission5-s3-personal-data-emmyselly-$SECGAME_USER_ID" --quiet
then
	echo "[SauerCloud] Cannot fill the bucket with required file. Retrying."
	if ! aws --profile "$SECGAME_USER_PROFILE" s3 cp aws_key_reminder.txt "s3://sauercloud-mission5-s3-personal-data-emmyselly-$SECGAME_USER_ID" --quiet
	then
		echo "[SauerCloud] Cannot fill the bucket with required file again. Check your internet connection. Rolling back."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshddbkey" -var="sshservicekey=$sshservicekey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
  		      	mkdir trash
		fi
		mv "./mission5-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SECGAME_USER_ID"
		exit 2
	fi
fi
rm aws_key_reminder.txt

#Return in mission dir
cd .. || exit

sleep 3

clear

#Write briefing
echo "This is it, Agent. \
We have finally managed to identify Evilcorp's home network. It is, of course, on a VPC on AWS. This is the very reason we contacted you. \
You're the best we've got, and I heard from our insider that this mission will be significantly harder than the previous ones. \
I've even heard that there is a trap in this one. Plan all your moves carefully...
You'll be able to ingress using these low-privileged AWS keys a bot sniffed from their github.
Best of luck to you, Agent... " > briefing.txt
echo "solus_aws_access_key = $solus_key_id" >> briefing.txt
echo "solus_aws_secret_access_key = $solus_secret_key" >> briefing.txt

echo "[SauerCloud] Mission 5 deployment complete. Mission folder is ./mission5-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd .. || exit
cat "mission5-$SECGAME_USER_ID/briefing.txt"