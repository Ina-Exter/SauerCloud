#!/bin/bash -e

echo "[AWS-Secgame] Enter the mission number you want to check the flag for (1, 2, 3, 4 or 5):"
read MISSION_NUMBER

if [[ ( "$MISSION_NUMBER" -lt 1 ) || ( "$MISSION_NUMBER" -gt 5 ) ]]
then
	echo "[AWS-Secgame] Invalid mission number."
	exit 1
fi

echo "[AWS-Secgame] Enter the flag for your mission, as you found it:"
read FLAG

if [[ $MISSION_NUMBER == 1 ]]
then
	if [[ $FLAG == "c2FsdHlwcm9ncmFtbWVyCg==" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the first mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	#possible to implement fake flag detector
	exit 1
elif [[ $MISSION_NUMBER == 2 ]]
then
	if [[ $FLAG == "catcats" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the second mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1
elif [[ $MISSION_NUMBER == 3 ]]
then
	if [[ $FLAG == "russianmanfinedfortakingfatcatonaplane" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the third mission!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1
elif [[ $MISSION_NUMBER == 4 ]]
then

elif [[ $MISSION_NUMBER == 5 ]]
then
	if [[ $FLAG == "Matt Steraker" ]]
	then
		echo "[AWS-Secgame] Congratulations! You solved the fifth mission, the \"big game\"!" 
		exit 0
	fi
	echo "[AWS-Secgame] The specified flag is incorrect. Did you paste it correctly? Or maybe you missed something."	
	exit 1

else
	echo "[AWS-Secgame] Invalid mission number."
fi

