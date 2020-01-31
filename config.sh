#!/bin/bash

echo "[SauerCloud] Enter the name of your default AWS profile that will create all challenges:"
read -r SAUERCLOUD_USER_PROFILE
if [[ -z "$SAUERCLOUD_USER_PROFILE" ]]
then
	echo "[SauerCloud] Error, no profile specified."
	echo "[SauerCloud] Abort."
	exit
fi
if [[ -e profile.txt ]]
then
	echo "[SauerCloud] File 'profile.txt' already exists. Overwrite? (y/n)"
	read -r answer
	if [[ "$answer" == "y" ]]
	then
		rm profile.txt
		touch profile.txt
		echo "$SAUERCLOUD_USER_PROFILE" >> profile.txt
	fi
else
	touch profile.txt
	echo  "$SAUERCLOUD_USER_PROFILE" >> profile.txt
fi
echo "[SauerCloud] $SAUERCLOUD_USER_PROFILE will be your default profile."
echo "[SauerCloud] SauerCloud can fetch your IP address directly and add it to the whitelist by cURL-ing \"icanhazip.com\". Do you wish to proceed? (y/N)"
read -r ans
if [[ ! "$ans" == "y" ]]
then
	echo "[SauerCloud] You may want to create a \"whitelist.txt\" file with your IP address in order to facilitate deployment."
	exit 2
fi	
echo "[SauerCloud] Fetching and whitelisting IP..."
if [[ -e "whitelist.txt" ]]
then
	echo "[SauerCloud] File 'whitelist.txt' already exists. Overwrite? (y/n)"
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
echo -n "[SauerCloud] Your ip is "; cat whitelist.txt
echo "[SauerCloud] Configuration complete."
