#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SAUERCLOUD_USER_PROFILE"
echo "[SauerCloud] Session ID: $SAUERCLOUD_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Request confirmation
echo "[SauerCloud] Destroy mission4-$SAUERCLOUD_USER_ID? (yes/no)"
echo "[SauerCloud] Only \"yes\" will be accepted as confirmation."
echo "[SauerCloud] Remember to delete anything you created yourself! Destroy might fail or stall if you do not."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[SauerCloud] Abort requested. Restoring target folder."
	cd ../../ || exit
	mv "./trash/mission4-$SAUERCLOUD_USER_ID" ./
	exit 2
fi

echo "[SauerCloud] Removing user policy"
policy_name=$(aws --profile "$SAUERCLOUD_USER_PROFILE" iam list-user-policies --user-name "juan-$SAUERCLOUD_USER_ID" --query PolicyNames[0] --output text)
aws --profile "$SAUERCLOUD_USER_PROFILE" iam delete-user-policy --user-name "juan-$SAUERCLOUD_USER_ID" --policy-name "$policy_name" > /dev/null 2>&1

#destroy terraform 
echo "[SauerCloud] Destroying terraform resources"
cd resources/terraform || exit

#check terraform destroy's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform destroy -auto-approve -var="profile=$SAUERCLOUD_USER_PROFILE" -var="id=$SAUERCLOUD_USER_ID" -var="ip=$USER_IP"
then
	echo "[SauerCloud] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission4-$SAUERCLOUD_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console."
	error_flag=1
fi


#destroy key pair
echo "[SauerCloud] Deleting key pair."
if ! aws --profile "$SAUERCLOUD_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission4-keypair-Evilcorp-Evilkeypair-$SAUERCLOUD_USER_ID"
then
	echo "[SauerCloud] Non-zero return code on keypair destruction. Use aws --profile $USER_SAUERCLOUD_PROFILE ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi

if [[ "$error_flag" -eq 1 ]]
then
	echo "[SauerCloud] Mission 4 destroy failed somewhere. Error messages should help you fix this."
	exit 1
fi
echo "[SauerCloud] Mission 4 destroy complete"
