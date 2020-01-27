#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#Given the extremely light nature of this script, the deployment will be fully handled with bash script and AWS cli, and not with terraform.
#Note that ALL commands are run with --quiet so as to avoid spoiling the user.

#ALWAYS assume that this script will run in the mission folder mission4-user_id

#Git data is zipped. Unzip it beforVe starting terraform
echo "[AWS-Secgame] Unzipping data."
cd resources
unzip -qq evilcorp-device-firmware.zip
#check return code
if [[ $? != 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on file extraction. Abort."
	cd ../..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv ./mission4-$SECGAME_USER_ID ./trash/
	exit 2
fi


#Initialize terraform
cd terraform
echo "[AWS-Secgame] Initializing terraform."
terraform init

#Pass the required variables (profile, region?, id, key) to terraform and plan
terraform plan -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID"

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
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID"

#check terraform apply's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if [[ $? != 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on terraform apply. Rolling back."
	terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID"
	cd ../../..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv ./mission4-$SECGAME_USER_ID ./trash/
	exit 2
fi

cd ../..

sleep 3

clear

# A briefing serves as a starting point for the user, now with extra hacky flavour!
touch briefing.txt
# Todo Write a more precise briefing to indicate user he's dealing with a firmware extract.
echo "You find a device inside their former hideout, you are able to extract the firmware. There is also a miterious WiFi connection \"EvilWifi\" that could be useful if only you knew the password...  Find anything valuable !" >> briefing.txt

echo "[AWS-Secgame] Mission 4 deployment complete. Mission folder is ./mission4-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd ..
cat mission4-$SECGAME_USER_ID/briefing.txt





