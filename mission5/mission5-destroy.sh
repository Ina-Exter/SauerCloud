#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will be run from the mission dir!

#Request confirmation
echo "[AWS-Secgame] Destroy mission5-$SECGAME_USER_ID? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Restoring target folder."
	cd ../../
	mv ./trash/mission5-$SECGAME_USER_ID ./
	exit 2
fi

#destroy terraform
echo "[AWS-Secgame] Destroying terraform resources"
cd resources/terraform
terraform refresh
terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP"
if [[ $? != 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission5-$SECGAME_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console."
fi


#destroy key pair
echo "[AWS-Secgame] Deleting key pair."
aws --profile $SECGAME_USER_PROFILE ec2 delete-key-pair --key-name AWS-secgame-mission5-keypair-ddb-handler-$SECGAME_USER_ID
if [[ $? != 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on keypair destruction. Use aws --profile $USER_SECGAME_PROFILE ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	exit 2
fi

#confirm destruction of both groups in case a user got placed in them
echo "[AWS-Secgame] Checking group deletion. If terraform raised an error about groups not being empty, this will get them. Otherwise, this command may fail if you did not go that far."
aws --profile $SECEGAME_USER_PROFILE iam delete-group --group-name privileged-$SEGAME_USER_ID
aws --profile $SECEGAME_USER_PROFILE iam delete-group --group-name suspects-$SEGAME_USER_ID

#destroy log group
echo "[AWS-Secgame] Deleting log groups. This command may fail if you did not go that far."
aws --profile $SECGAME_USER_PROFILE logs delete-log-group --log-group-name /aws/lambda/AWS-secgame-mission5-lambda-logs-dump-$SECGAME_USER_ID
aws --profile $SECGAME_USER_PROFILE logs delete-log-group --log-group-name /aws/lambda/AWS-secgame-mission5-lambda-change-group-$SECGAME_USER_ID

echo "[AWS-Secgame] Mission 5 destroy complete"
