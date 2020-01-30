#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SECGAME_USER_PROFILE"
echo "[SauerCloud] Session ID: $SECGAME_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume that this script will run in the mission folder mission2-user_id

#A ssh private key should also be generated and passed as parameter.
echo "[SauerCloud] Generating ssh key for ec2"
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 create-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID" --query 'KeyMaterial' --output text >> resources/ssh_key.pem
then
	echo "[SauerCloud] Non-zero return code on operation. Abort."
	cd .. || exit
	#No resource has been created, just delete the folder
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv "mission3-$SECGAME_USER_ID" ./trash/
	exit 2
fi
sshkey=$(<resources/ssh_key.pem)
chmod 400 resources/ssh_key.pem

#Initialize terraform
cd resources/terraform || exit
echo "[SauerCloud] Initializing terraform."
terraform init

#Pass the required variables (profile, region?, id, key) to terraform and plan
terraform plan -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"

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
	mv "./mission3-$SECGAME_USER_ID" ./trash/
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
#check terraform apply's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
then
	echo "[SauerCloud] Non-zero return code on terraform apply. Rolling back."
	terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
	cd ../../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission3-$SECGAME_USER_ID" ./trash/
	aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
	exit 2
fi


#Get terraform's outputs
ec2_ip=$(terraform output ec2_ip_addr)
ec2_id=$(terraform output ec2_instance_id)

#Instance setup as defined in the workflow in resources
cd .. || exit #now in resources

#wait, else scp will get all pissy on me
echo "[SauerCloud] Waiting for completion of EC2 startup (8s)."
sleep 8

#scp all the required data in
echo "[SauerCloud] Importing instance data."
if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q -r ./chonks "ec2-user@$ec2_ip:/home/ec2-user/"
then
	echo "[SauerCloud] Unable to safely copy files on instance. Retrying."
	if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q -r ./chonks "ec2-user@$ec2_ip:/home/ec2-user/"
	then
		echo "[SauerCloud] Unable to safely copy files on instance (second attempt). Check your internet connection. Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
   		    mkdir trash
		fi
		mv "./mission3-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
		exit 2
	fi
fi

if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q bob_todo.txt "ec2-user@$ec2_ip:/home/ec2-user/"
then
	echo "[SauerCloud] Unable to safely copy files on instance. Retrying."
	if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q bob_todo.txt "ec2-user@$ec2_ip:/home/ec2-user/"
	then
		echo "[SauerCloud] Unable to safely copy files on instance (second attempt). Check your internet connection. Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
        	mkdir trash
		fi
		mv "./mission3-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
		exit 2
	fi
fi

if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q mounting_on_linux_for_evil_dummies.txt "ec2-user@$ec2_ip:/home/ec2-user/"
then
	echo "[SauerCloud] Unable to safely copy files on instance. Retrying."
	if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q bob_todo.txt "ec2-user@$ec2_ip:/home/ec2-user/"
	then
		echo "[SauerCloud] Unable to safely copy files on instance (second attempt). Check your internet connection. Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
				mkdir trash
		fi
		mv "./mission3-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
		exit 2
	fi
fi


#Snapshot
echo "[SauerCloud] Snapshotting instance."
volumeID=$(aws --profile "$SECGAME_USER_PROFILE" ec2 describe-instance-attribute --attribute blockDeviceMapping --instance-id "$ec2_id" --query 'BlockDeviceMappings[0].Ebs.VolumeId' --output text)
if ! snapshotID=$(aws --profile "$SECGAME_USER_PROFILE" ec2 create-snapshot --volume-id "$volumeID" --query 'SnapshotId' --output text)
then
	echo "[SauerCloud] Unable to generate instance snapshot. Retrying."
	if ! snapshotID=$(aws --profile "$SECGAME_USER_PROFILE" ec2 create-snapshot --volume-id "$volumeID" --query 'SnapshotId' --output text)
	then
		echo "[SauerCloud] Unable to generate instance snapshot (second attempt). Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
				mkdir trash
		fi
		mv "./mission3-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
		exit 2
	fi
fi

echo "$snapshotID" >> snapshotid.txt

#scp cleanup script and execute it
echo "[SauerCloud] Setting up instance environment"
if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q cleanup_script.sh "ec2-user@$ec2_ip:/home/ec2-user/"
then
	echo "[SauerCloud] Unable to safely send cleanup_script.sh to instance. Reutrying."
	if ! scp -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q cleanup_script.sh "ec2-user@$ec2_ip:/home/ec2-user/"
	then
		echo "[SauerCloud] Unable to safely send cleanup_script.sh to instance (second attempt). Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
				mkdir trash
		fi
		mv "./mission3-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-snapshot --snapshot-id "$snapshotID"
		exit 2
	fi
fi

if ! ssh -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q  "ec2-user@$ec2_ip" 'chmod u+x cleanup_script.sh; ./cleanup_script.sh; exit'
then
	echo "[SauerCloud] Unable to start remote cleanup script. Retrying."
	if ! ssh -i "ssh_key.pem" -o "StrictHostKeyChecking=no" -q  "ec2-user@$ec2_ip" 'chmod u+x cleanup_script.sh; ./cleanup_script.sh; exit'
	then	
		echo "[SauerCloud] Unable to start remote cleanup script (second attempt). Abort."
		cd terraform || exit
		terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP" -var="sshprivatekey=$sshkey"
		cd ../../.. || exit
		#If trash doesn't exist, make it
		if [[ ! -d "trash" ]]
		then
				mkdir trash
		fi
		mv "./mission3-$SECGAME_USER_ID" ./trash/
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
		aws --profile "$SECGAME_USER_PROFILE" ec2 delete-snapshot --snapshot-id "$snapshotID"
		exit 2
	fi
fi


#Give user the ssh key
cp ssh_key.pem ./../

#Return in mission dir
cd .. || exit

sleep 3

clear

#Write briefing
echo "Agent, you are a godsent. Well done fetching those blueprints on that other server. The brass were delighted. You will find the usual pay on your usual account. \
We have another task for you. Our insider told us about a suspicious instance. Apparently, they intend to use it for a powerful wave of cyber-attacks. \
It was also brought to our attention that the instance contained sensitive data, but they have been redacted after some time. \
We have provided you with leaked AWS keys to their account, but they have little to no privilege. Your job is to access the instance, then escalate your privileges and do some forensics on it in order to get the sensitive data out, and after that, you are free to do with the server as you please. Shutting it down would be wiser.
We have great hopes for you.

The ssh key you need is in mission3-$SECGAME_USER_ID/ssh_key.pem.
Instance ip address: $ec2_ip

PS: Remember, agent. If you create any resources yourself, delete them before deleting the mission. Terraform will not be able to handle them.
" >> briefing.txt

echo "[SauerCloud] Mission 3 deployment complete. Mission folder is ./mission3-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd .. || exit
cat "mission3-$SECGAME_USER_ID/briefing.txt"


