#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Request confirmation
echo "[AWS-Secgame] Destroy mission1-$SECGAME_USER_ID? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Restoring target folder."
	cd ../../
	mv ./trash/mission1-$SECGAME_USER_ID ./
	exit 2
fi

#destroy terraform
echo "[AWS-Secgame] Destroying terraform resources"
cd resources/terraform
terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE"

echo "[AWS-Secgame] Mission 1 destroy complete."
exit 0
