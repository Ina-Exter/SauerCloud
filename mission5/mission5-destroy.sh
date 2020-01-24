#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Request confirmation
echo "[AWS-Secgame] Destroy mission5-$SECGAME_USER_ID? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Restoring target folder."
	cd ../../ || exit
	mv "./trash/mission5-$SECGAME_USER_ID" ./
	exit 2
fi

#destroy terraform
#First, empty the groups in case
echo "[AWS-Secgame] Emptying groups, may fail."
aws --profile "$SECGAME_USER_PROFILE" iam remove-user-from-group --group-name "privileged-$SECGAME_USER_ID" --user-name "emmyselly-$SECGAME_USER_ID"
aws --profile "$SECGAME_USER_PROFILE" iam remove-user-from-group --group-name "suspects-$SECGAME_USER_ID" --user-name "emmyselly-$SECGAME_USER_ID"

#destroy user keys
echo "[AWS-Secgame] Deleting extra user keys."
cd resources/terraform || exit
#check if user made a new key
es_standard_key=$(terraform output emmyselly_key)
es_maybe_new_key=$(aws --profile "$SECGAME_USER_PROFILE" iam list-access-keys --user-name "emmyselly-$SECGAME_USER_ID" --query AccessKeyMetadata[0].AccessKeyId)
es_maybe_new_key="${es_maybe_new_key:1: -1}"
if [[ "$es_standard_key" == "$es_maybe_new_key" ]]
then
	#same key. check if the other is the new key
	es_maybe_new_key=$(aws --profile "$SECGAME_USER_PROFILE" iam list-access-keys --user-name "emmyselly-$SECGAME_USER_ID" --query AccessKeyMetadata[1].AccessKeyId)
	es_maybe_new_key="${es_maybe_new_key:1: -1}"
	if [[ ! "$es_standard_key" == "$es_maybe_new_key" ]]
	then
		#ok, this one is the new key, destroy it
		aws --profile "$SECGAME_USER_PROFILE" iam delete-access-key --access-key-id "$es_maybe_new_key" --user-name "emmyselly-$SECGAME_USER_ID" > /dev/null 2>&1
	fi #if not, [1] is most likely void. carry on.
else
	#new key. destroy it and carry on.
	aws --profile "$SECGAME_USER_PROFILE" iam delete-access-key --access-key-id "$es_maybe_new_key" --user-name "emmyselly-$SECGAME_USER_ID" > /dev/null 2>&1
fi

echo "[AWS-Secgame] Destroying terraform resources"
if ! terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE" -var="id=$SECGAME_USER_ID" -var="ip=$USER_IP"
then
	echo "[AWS-Secgame] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission5-$SECGAME_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console)."
	echo "[AWS-Secgame] If this was raised by a group issue, the script should handle it."
	error_flag=1
fi

#destroy key pair
echo "[AWS-Secgame] Deleting key pair."
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "AWS-secgame-mission5-keypair-ddb-handler-$SECGAME_USER_ID"
then
	echo "[AWS-Secgame] Non-zero return code on keypair destruction. Use aws --profile \"$USER_SECGAME_PROFILE\" ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi
if ! aws --profile "$SECGAME_USER_PROFILE" ec2 delete-key-pair --key-name "AWS-secgame-mission5-keypair-service-$SECGAME_USER_ID"
then
	echo "[AWS-Secgame] Non-zero return code on keypair destruction. Use aws --profile \"$USER_SECGAME_PROFILE\" ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi


#destroy log group
echo "[AWS-Secgame] Deleting log groups."
aws --profile "$SECGAME_USER_PROFILE" logs delete-log-group --log-group-name "/aws/lambda/AWS-secgame-mission5-lambda-logs-dump-$SECGAME_USER_ID" > /dev/null 2>&1
aws --profile "$SECGAME_USER_PROFILE" logs delete-log-group --log-group-name "/aws/lambda/AWS-secgame-mission5-lambda-change-group-$SECGAME_USER_ID" > /dev/null 2>&1

if [[ "$error_flag" -eq 1 ]]
then
	echo "[AWS-Secgame] Mission 1 destroy failed somewhere. Error messages should help you fix this."
	exit 1
fi
echo "[AWS-Secgame] Mission 5 destroy complete"
