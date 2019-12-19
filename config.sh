#!/bin/bash

echo "[AWS-Secgame] Enter the name of your default AWS profile that will create all challenges:"
read -r SECGAME_USER_PROFILE
if [[ -z "$SECGAME_USER_PROFILE" ]]
then
	echo "[AWS-Secgame] Error, no profile specified."
	echo "[AWS-Secgame] Abort."
	exit
fi
if [[ -e profile.txt ]]
then
	echo "[AWS-Secgame] File 'profile.txt' already exists. Overwrite? (y/n)"
	read -r answer
	if [[ "$answer" == "y" ]]
	then
		rm profile.txt
		touch profile.txt
		echo "$SECGAME_USER_PROFILE" >> profile.txt
	fi
else
	touch profile.txt
	echo  "$SECGAME_USER_PROFILE" >> profile.txt
fi
echo "[AWS-Secgame] $SECGAME_USER_PROFILE will be your default profile."
echo "[AWS-Secgame] AWS-Secgame can fetch your IP address directly and add it to the whitelist by cURL-ing \"icanhazip.com\". Do you wish to proceed? (y/N)"
read -r ans
if [[ ! "$ans" == "y" ]]
then
	echo "[AWS-Secgame] You may want to create a \"whitelist.txt\" file with your IP address in order to facilitate deployment."
	exit 2
fi	
echo "[AWS-Secgame] Fetching and whitelisting IP..."
if [[ -e "whitelist.txt" ]]
then
	echo "[AWS-Secgame] File 'whitelist.txt' already exists. Overwrite? (y/n)"
	read -r answer
	if [[ "$answer" == "y" ]]
	then
		rm whitelist.txt
		touch whitelist.txt
	fi
else
	touch whitelist.txt
fi
curl -f -s icanhazip.com >>  whitelist.txt
echo -n "[AWS-Secgame] Your ip is "; cat whitelist.txt
echo "[AWS-Secgame] Configuration complete."
