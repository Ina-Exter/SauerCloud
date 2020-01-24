#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Request confirmation
echo "[AWS-Secgame] Destroy mission3-$SECGAME_USER_ID? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Restoring target folder."
	cd ../../ || exit
	mv "./trash/mission3-$SECGAME_USER_ID" ./
	exit 2
fi

#destroy terraform
echo "[AWS-Secgame] Destroying terraform resources"
cd resources/terraform || exit
#check terraform destroy's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP"
then
	echo "[AWS-Secgame] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission3-$SECGAME_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console."
	error_flag=1
fi

#destroy key pair
echo "[AWS-Secgame] Deleting key pair."
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "AWS-secgame-mission3-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID"
then
	echo "[AWS-Secgame] Non-zero return code on keypair destruction. Use aws --profile $USER_SECGAME_PROFILE ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi

#destroy snapshot
echo "[AWS-Secgame] Deleting snapshot."
cd .. || exit
snapshotID=$(head -n 1 snapshotid.txt)
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 delete-snapshot --snapshot-id "$snapshotID"
then
	echo "[AWS-Secgame] Non-zero return code on snapshot destruction. Use aws --profile $USER_SECGAME_PROFILE ec2 describe-snapshots and delete-snapshot to manually delete it if needed."
	error_flag=1
fi
echo "[AWS-Secgame] Remember to delete the volume you created yourself!"

if [[ "$error_flag" -eq 1 ]]
then
	echo "[AWS-Secgame] Mission 1 destroy failed somewhere. Error messages should help you fix this."
	exit 1
fi
echo "[AWS-Secgame] Mission 3 destroy complete"
