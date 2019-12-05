#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Request confirmation
echo "[AWS-Secgame] Destroy mission4-$SECGAME_USER_ID? (yes/no)"
echo "[AWS-Secgame] Only \"yes\" will be accepted as confirmation."
read answer
if [[ ! $answer == "yes" ]]
then
	echo "[AWS-Secgame] Abort requested. Restoring target folder."
	cd ../../
	mv ./trash/mission4-$SECGAME_USER_ID ./
	exit 2
fi

#destroy terraform
echo "[AWS-Secgame] Destroying terraform resources"
cd resources/terraform
terraform destroy -auto-approve -var="profile=$SECGAME_USER_PROFILE"
#check terraform destroy's return code, act depending on it. 0 is for a flawless execution, 1 means an error has arisen
if [[ $? != 0 ]]
then
	echo "[AWS-Secgame] Non-zero return code on terraform destroy. There might be a problem. Consider destroying by hand (move to /trash/mission4-$SECGAME_USER_ID/resources/terraform and use terraform destroy, or destroy your resources by hand on the console."
	exit 2
fi

echo "[AWS-Secgame] Mission 4 destroy complete."
exit 0
