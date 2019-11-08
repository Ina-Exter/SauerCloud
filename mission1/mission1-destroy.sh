#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#This option checks that the script did not start with --abort, which skips user confirmation and focuses on resource destruction
if [[ $1 == "--abort" ]]
then
	#Bucket destruction
	aws --profile $SECGAME_USER_PROFILE s3 rb s3://evilcorp-evilbucket-$SECGAME_USER_ID --force
	cd ..
	if [[ ! -d "trash" ]]
	then
	       	mkdir trash
	fi
	mv mission1-$SECGAME_USER_ID ./trash/
	exit 7
fi

#Request consent, restore if not given
echo "[AWS-Secgame] This will destroy all mission1-associated resources. Is this acceptable? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "Abort requested. Restoring target folder."
	cd ../..
	mv ./trash/mission1-$SECGAME_USER_ID .
	exit 2
fi


#Destroy the bucket based on user ID. User ID should be passed by start.sh
echo "[AWS-Secgame] Force-destroying bucket"
aws --profile $SECGAME_USER_PROFILE s3 rb s3://evilcorp-evilbucket-$SECGAME_USER_ID --force

echo "[AWS-Secgame] Mission 1 destroy complete."
exit 0
