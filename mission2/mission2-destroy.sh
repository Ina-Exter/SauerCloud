#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will be run from the mission dir!

#Request confirmation
echo "[AWS-Secgame] Destroy mission2-$SECGAME_USER_ID? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Restoring target folder."
	cd ../../
	mv ./trash/mission2-$SECGAME_USER_ID ./
	exit 2
fi

#destroy terraform
echo "[AWS-Secgame] Destroying terraform resources"
cd resources/terraform
terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP"

#destroy key pair
echo "[AWS-Secgame] Deleting key pair."
aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID


echo "[AWS-Secgame] Mission 2 destroy complete"
