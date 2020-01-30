#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SECGAME_USER_PROFILE"
echo "[SauerCloud] Session ID: $SECGAME_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#Given the extremely light nature of this script, the deployment will be fully handled with bash script and AWS cli, and not with terraform.
#Note that ALL commands are run with --quiet so as to avoid spoiling the user.

#ALWAYS assume that this script will run in the mission folder mission1-user_id

#Git data is zipped. Unzip it before starting terraform
echo "[SauerCloud] Unzipping data."
cd resources || exit

#check return code
if ! unzip -qq evilcorp-evilbucket-data.zip
then
	echo "[SauerCloud] Non-zero return code on file extraction. Abort."
	cd ../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission1-$SECGAME_USER_ID" ./trash/
	exit 2
fi


#Initialize terraform
cd terraform || exit
echo "[SauerCloud] Initializing terraform."
terraform init

#Pass the required variables (profile, region?, id, key) to terraform and plan
terraform plan -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID"

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
	mv "./mission1-$SECGAME_USER_ID" ./trash/
	exit 2
fi

#DEPLOYYYYYYYYYYYYYYYYYYYY
#check terraform apply's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform apply -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID"
then
	echo "[SauerCloud] Non-zero return code on terraform apply. Rolling back."
	echo "[SauerCloud] If this problem happened because of s3 files being incorrectly listed in terraform or being not found, try running the \"create_s3_tf.sh\" script in mission1/resources."
	terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID"
	cd ../../.. || exit
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi
	mv "./mission1-$SECGAME_USER_ID" ./trash/
	exit 2
fi

cd ../.. || exit

sleep 3

clear

# A briefing serves as a starting point for the user, now with extra hacky flavour!
touch briefing.txt
echo "Greetings, agent. Our company received strange reports regarding another large-scale, multinational company called EvilCorp. \
Word has it that they are plotting something. Something bad. However, our informants have found a lead. \
Our guy working at Amazon Web Services reported seeing the name of Evilcorp passing by in an S3 report. There may be something to see. \
Look up their evilcorp-evilbucket-$SECGAME_USER_ID bucket. There should be interesting files on there, and a hint regarding their plans..." >> briefing.txt

echo "[SauerCloud] Mission 1 deployment complete. Mission folder is ./mission1-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd ..
cat "mission1-$SECGAME_USER_ID/briefing.txt"





