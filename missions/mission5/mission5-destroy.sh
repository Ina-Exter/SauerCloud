#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SAUERCLOUD_USER_PROFILE"
echo "[SauerCloud] Session ID: $SAUERCLOUD_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Request confirmation
echo "[SauerCloud] Destroy mission5-$SAUERCLOUD_USER_ID? (yes/no)"
echo "[SauerCloud] Only \"yes\" will be accepted as confirmation."
echo "[SauerCloud] Remember to delete anything you created yourself! Destroy might fail or stall if you do not."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[SauerCloud] Abort requested. Restoring target folder."
	cd ../../ || exit
	mv "./trash/mission5-$SAUERCLOUD_USER_ID" ./
	exit 2
fi

#destroy terraform
#First, empty the groups in case
echo "[SauerCloud] Emptying groups, may fail."
aws --profile "$SAUERCLOUD_USER_PROFILE" iam remove-user-from-group --group-name "privileged-$SAUERCLOUD_USER_ID" --user-name "emmyselly-$SAUERCLOUD_USER_ID"
aws --profile "$SAUERCLOUD_USER_PROFILE" iam remove-user-from-group --group-name "suspects-$SAUERCLOUD_USER_ID" --user-name "emmyselly-$SAUERCLOUD_USER_ID"

#destroy user keys
echo "[SauerCloud] Deleting extra user keys."
cd resources/terraform || exit
#check if user made a new key
es_standard_key=$(terraform output emmyselly_key)
es_maybe_new_key=$(aws --profile "$SAUERCLOUD_USER_PROFILE" iam list-access-keys --user-name "emmyselly-$SAUERCLOUD_USER_ID" --query AccessKeyMetadata[0].AccessKeyId)
es_maybe_new_key="${es_maybe_new_key:1: -1}"
if [[ "$es_standard_key" == "$es_maybe_new_key" ]]
then
	#same key. check if the other is the new key
	es_maybe_new_key=$(aws --profile "$SAUERCLOUD_USER_PROFILE" iam list-access-keys --user-name "emmyselly-$SAUERCLOUD_USER_ID" --query AccessKeyMetadata[1].AccessKeyId)
	es_maybe_new_key="${es_maybe_new_key:1: -1}"
	if [[ ! "$es_standard_key" == "$es_maybe_new_key" ]]
	then
		#ok, this one is the new key, destroy it
		aws --profile "$SAUERCLOUD_USER_PROFILE" iam delete-access-key --access-key-id "$es_maybe_new_key" --user-name "emmyselly-$SAUERCLOUD_USER_ID" > /dev/null 2>&1
	fi #if not, [1] is most likely void. carry on.
else
	#new key. destroy it and carry on.
	aws --profile "$SAUERCLOUD_USER_PROFILE" iam delete-access-key --access-key-id "$es_maybe_new_key" --user-name "emmyselly-$SAUERCLOUD_USER_ID" > /dev/null 2>&1
fi

echo "[SauerCloud] Destroying terraform resources"
if ! terraform destroy -auto-approve -var="profile=$SAUERCLOUD_USER_PROFILE" -var="id=$SAUERCLOUD_USER_ID" -var="ip=$USER_IP"
then
	echo "[SauerCloud] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission5-$SAUERCLOUD_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console)."
	echo "[SauerCloud] If this was raised by a group issue, the script should handle it."
	error_flag=1
fi

#destroy key pair
echo "[SauerCloud] Deleting key pair."
if ! aws --profile "$SAUERCLOUD_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-ddb-handler-$SAUERCLOUD_USER_ID"
then
	echo "[SauerCloud] Non-zero return code on keypair destruction. Use aws --profile \"$USER_SAUERCLOUD_PROFILE\" ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi
if ! aws --profile "$SAUERCLOUD_USER_PROFILE" ec2 delete-key-pair --key-name "SauerCloud-mission5-keypair-service-$SAUERCLOUD_USER_ID"
then
	echo "[SauerCloud] Non-zero return code on keypair destruction. Use aws --profile \"$USER_SAUERCLOUD_PROFILE\" ec2 describe-key-pairs and delete-key-pair to manually delete the key pair if needed."
	error_flag=1
fi


#destroy log group
echo "[SauerCloud] Deleting log groups."
aws --profile "$SAUERCLOUD_USER_PROFILE" logs delete-log-group --log-group-name "/aws/lambda/SauerCloud-mission5-lambda-logs-dump-$SAUERCLOUD_USER_ID" > /dev/null 2>&1
aws --profile "$SAUERCLOUD_USER_PROFILE" logs delete-log-group --log-group-name "/aws/lambda/SauerCloud-mission5-lambda-change-group-$SAUERCLOUD_USER_ID" > /dev/null 2>&1

if [[ "$error_flag" -eq 1 ]]
then
	echo "[SauerCloud] Mission 5 destroy failed somewhere. Error messages should help you fix this."
	exit 1
fi
echo "[SauerCloud] Mission 5 destroy complete"
