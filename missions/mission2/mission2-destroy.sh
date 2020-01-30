#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SECGAME_USER_PROFILE"
echo "[SauerCloud] Session ID: $SECGAME_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!
error_flag=0

#Request confirmation
echo "[SauerCloud] Destroy mission2-$SECGAME_USER_ID? (yes/no)"
echo "[SauerCloud] Only \"yes\" will be accepted as confirmation."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[SauerCloud] Abort requested. Restoring target folder."
	cd ../../ || exit
	mv "./trash/mission2-$SECGAME_USER_ID" ./
	exit 2
fi

#destroy terraform
echo "[SauerCloud] Destroying terraform resources"
cd resources/terraform || exit
#check terraform destroy's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP"
then
	echo "[SauerCloud] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission2-$SECGAME_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console."
	error_flag=1
fi


#destroy key pair
echo "[SauerCloud] Deleting key pair."
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
then
	echo "[SauerCloud] Non-zero return code on keypair destruction. Use aws --profile $USER_SECGAME_PROFILE ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi

if [[ "$error_flag" -eq 1 ]]
then
	echo "[SauerCloud] Mission 2 destroy failed somewhere. Error messages should help you fix this."
	exit 1
fi
echo "[SauerCloud] Mission 2 destroy complete"
