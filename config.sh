#!/bin/bash

echo "[AWS-Secgame] Enter the name of your default AWS profile that will create all challenges:"
read SECGAME_USER_PROFILE
if [[ -z "$SECGAME_USER_PROFILE" ]]
then
	echo "[AWS-Secgame] Error, no profile specified."
	echo "[AWS-Secgame] Abort."
	exit
fi
if [[ -e profile ]]
then
	echo "[AWS-Secgame] File 'profile' already exists. Overwrite? (y/n)"
	read answer
	if [[ $answer == "y" ]]
	then
		rm profile
		touch profile
		echo $SECGAME_USER_PROFILE >> profile
	fi
else
	touch profile
	echo  $SECGAME_USER_PROFILE >> profile
fi
echo "[AWS-Secgame] $SECGAME_USER_PROFILE will be your default profile."
echo "[AWS-Secgame] Fetching and whitelisting IP..."
if [[ -e whitelist ]]
then
	echo "[AWS-Secgame] File 'whitelist' already exists. Overwrite? (y/n)"
	read answer
	if [[ $answer == "y" ]]
	then
		rm whitelist
		touch whitelist
	fi
else
	touch whitelist
fi
curl -f -s icanhazip.com >>  whitelist
echo -n "[AWS-Secgame] Your ip is "; cat whitelist
echo "[AWS-Secgame] Configuration complete."
