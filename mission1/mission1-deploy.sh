#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#Given the extremely light nature of this script, the deployment will be fully handled with bash script and AWS cli, and not with terraform.
#Note that ALL commands are run with --quiet so as to avoid spoiling the user.

#ALWAYS assume that this script will run in the mission folder mission1-user_id

#Request consent, deploy only if given
echo "[AWS-Secgame] This will setup the first mission's bucket and associated resources. Is this acceptable? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Destroying target folder."
	cd ..
	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv mission1-$SECGAME_USER_ID ./trash/
	exit 2
fi

#This first command makes a new bucket called evilcorp-evilbucket-user_id.
aws --profile $SECGAME_USER_PROFILE s3 mb s3://evilcorp-evilbucket-$SECGAME_USER_ID
if [[ ! $? == 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on operation. Abort."
	cd ..
	#No resource has been created, just delete the folder
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv mission1-$SECGAME_USER_ID ./trash/
	exit 2
fi
echo "[AWS-Secgame] Bucket created"

#Git data is zipped. Unzip it before the transfer
cd resources
unzip -qq evilcorp-evilbucket-data.zip
cd ..

#Copy the files onto the bucket.
aws --profile $SECGAME_USER_PROFILE s3 --quiet cp ./resources/evilcorp-evilbucket-data s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive
if [[ ! $? == 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on operation. Abort."
	#If this fails, then the delete script has to be ran...
	source ./mission1-destroy.sh --abort
	exit 2
fi
echo "[AWS-Secgame] Ressources copied on bucket"

#Sets the bucket's ACL (access control list) to public for maximum vulnerability
aws --profile $SECGAME_USER_PROFILE s3api put-bucket-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID
if [[ ! $? == 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on operation. Abort."
	#If this fails, then the delete script has to be ran...
	source ./mission1-destroy.sh --abort
	exit 2
fi
echo "[AWS-Secgame] Bucket ACL set"

#This gets a bit tacky. All files also have to have public access, and I found no better way than to pipe it all together and pray.
#This essentially lists bucket content, then for each, sets ACL as public-read. Since .git folders a a bit large, this may take up to 30 seconds.
echo "[AWS-Secgame] Setting file ACL, please wait (expected wait under 1 minute)."
aws --profile $SECGAME_USER_PROFILE s3 ls s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive|awk '{cmd="aws --profile $SECGAME_USER_PROFILE s3api put-object-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID --key "$4; system(cmd)}'
if [[ ! $? == 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on operation. Abort."
	#If this fails, then the delete script has to be ran...
	source ./mission1-destroy.sh --abort
	exit 2
fi
echo "[AWS-Secgame] File ACL set"

# A briefing serves as a starting point for the user, now with extra hacky flavour!
touch briefing.txt
echo "Greetings, agent. Our company received strange reports regarding another large-scale, multinational company called EvilCorp \
Word has it that they are plotting something. Something bad. However, our informants have found a lead. \
Our guy working at Amazon Web Services reported seeing the name of Evilcorp passing by in an S3 report. There may be something to see. \
Look up their evilcorp-evilbucket-$SECGAME_USER_ID bucket. There should be interesting files on there, and a hint regarding their plans..." >> briefing.txt

echo "[AWS-Secgame] Mission 1 deployment complete. Mission folder is ./mission1-$SECGAME_USER_ID. Read the briefing to begin, a copy can be found in the mission folder."

echo "##############################################################################################"
echo "#                                                                                            #"
echo "#                                   INCOMING TRANSMISSION                                    #"
echo "#                                                                                            #"
echo "##############################################################################################"

cd ..
cat mission1-$SECGAME_USER_ID/briefing.txt





