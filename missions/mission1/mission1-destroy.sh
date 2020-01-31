#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[SauerCloud] Master account profile: $SAUERCLOUD_USER_PROFILE"
echo "[SauerCloud] Session ID: $SAUERCLOUD_USER_ID"
echo "[SauerCloud] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!
error_flag=0

#Request confirmation
echo "[SauerCloud] Destroy mission1-$SAUERCLOUD_USER_ID? (yes/no)"
echo "[SauerCloud] Only \"yes\" will be accepted as confirmation."
read -r answer
if [[ ! $answer == "yes" ]]
then
	echo "[SauerCloud] Abort requested. Restoring target folder."
	cd ../../ || exit
	mv "./trash/mission1-$SAUERCLOUD_USER_ID" ./
	exit 2
fi

#destroy terraform
echo "[SauerCloud] Destroying terraform resources"
cd resources/terraform || exit

#check terraform destroy's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if ! terraform destroy -auto-approve -var="profile=$SAUERCLOUD_USER_PROFILE"
then
	echo "[SauerCloud] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission1-$SAUERCLOUD_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console."
	error_flag=1
fi

if [[ "$error_flag" -eq 1 ]]
then
	echo "[SauerCloud] Mission 1 destroy failed somewhere. Error messages should help you fix this."
	exit 1
fi
echo "[SauerCloud] Mission 1 destroy complete."
exit 0
