#!/bin/bash
set -e

echo "[AWS-Secgame] Enter the mission number you want to check the flag for (1, 2, 3, 4 or 5):"
read -r MISSION_NUMBER
MISSION_NUMBER=${MISSION_NUMBER//_/}
MISSION_NUMBER=${MISSION_NUMBER// /_}
MISSION_NUMBER=${MISSION_NUMBER//[^a-zA-Z0-9_=]/}


if [[ ( "$MISSION_NUMBER" -lt 1 ) || ( "$MISSION_NUMBER" -gt 5 ) ]]
then
	echo "[AWS-Secgame] Invalid mission number."
	exit 1
fi

echo "[AWS-Secgame] Enter the flag for your mission, as you found it:"
read -r FLAG

if [[ $MISSION_NUMBER -eq 1 ]]
then
	if [[ $FLAG == "c2FsdHlwcm9ncmFtbWVyCg==" ]] || [[ $FLAG == "saltyprogrammer" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the first mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1
elif [[ $MISSION_NUMBER -eq 2 ]]
then
	if [[ $FLAG == "catcats" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the second mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1
elif [[ $MISSION_NUMBER -eq 3 ]]
then
	if [[ $FLAG == "russianmanfinedfortakingfatcatonaplane" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the third mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1
elif [[ $MISSION_NUMBER -eq 4 ]]
then
	if [[ $FLAG == "cmFnZG9sbGRydWdiYXJvbg==" ]] || [[ $FLAG == "ragdolldrugbaron" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the fourth mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1
elif [[ $MISSION_NUMBER -eq 5 ]]
then
	if [[ $FLAG == "Matt Steraker" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the fifth mission, the \"big game\". Hope you liked it!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1

else
	echo "[AWS-Secgame] Invalid mission number."
fi

