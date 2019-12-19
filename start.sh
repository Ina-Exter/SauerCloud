#!/bin/bash

############################################################
#                                                          #
#              AWS OFFENSIVE SECURITY GAME                 #
#                         About                            #
############################################################

#This security game is initially developed for internal use 
#by society Stack Labs. Its future uses are not limited to 
#this and should not be considered a company exclusivity.

#These scripts and most of the resources were made by
#Xavier Goffin (xaviergoffin42@gmail.com, xavier.goffin@stack-labs.com)
#I am not responsible for any billing charges incurred when using this program.

############################################################
#                                                          #
#                      SANITY CHECKS                       #
#                     Cthulhu F'taghn                      #
############################################################

#If user requests help, do not send him packing
if [[ "$1" = "help" ]]
then
	echo "[AWS-Secgame] AWS-Secgame (name subject to change) is a bash-and-terraform deployment framework in order to setup \"nice\" and \"fun\" challenges to sensbilize to AWS vulnerabilities caused by misconfigurations." #work in progress, insert more coffee
	echo "[AWS-Secgame] Usage: ./start.sh command mission"
	echo "[AWS-Secgame] Commands: create => deploy the specified mission infrastructure on AWS."
	echo "[AWS-Secgame] Commands: destroy => delete the specified mission infrastructure from AWS."
	echo "[AWS-Secgame] Commands: help => Display this helptext. No, it won't work with a \"mission\" argument :^)"
	echo "[AWS-Secgame] Missions: Range from mission1 to mission5. Missions 1 to 4 are small missions for training. Mission 5 is a large framework for a real CTF game. It is significantly longer than the others."
	echo "[AWS-Secgame] You may have to execute ./config.sh beforehand in order to specify your AWS CLI account, and whitelist your IP address."
	exit 2
fi

#If user failed a configuration step, kindly remind him to go do it
if [ ! -e profile.txt ] || [ ! -e whitelist.txt ]
then
	echo "[AWS-Secgame] Please configure your default profile and whitelist ip before starting missions. Run ./config in order to write these files."
	exit 2
fi

#If user wrote more than 2 arguments, or less than 2 (excluding the one case with just "help", explain the error.
if [[ 2 -ne "$#" ]]
then
	echo -n "[AWS-Secgame] Illegal argument error. start.sh requires exactly 2 arguments."
	echo " Supplied $# argument(s)."
	echo "[AWS-Secgame] See ./start.sh help to display helptext."
	exit 2
fi

############################################################
#                                                          #
#                  ENVIRONMENT HANDLING                    #
#                                                          #
############################################################

#Load environment variables from files profile.txt and whitelist.txt
export SECGAME_USER_PROFILE=$(head -n 1 profile.txt)
export USER_IP=$(head -n 1 whitelist.txt)

#Display warning regarding IP
export test_ip=$(curl icanhazip.com --silent)

if [[ ! "$USER_IP" == "$test_ip" ]]
then
	echo "[AWS-Secgame] Current IP address and IP address registered in whitelist.txt do not match. The security group will deny you access. Proceed? ((y)es/(n)o/(r)eplace)"
	read -r ans
	if [[ "$ans" == "y" ]] || [[ "$ans" == "yes" ]]
	then
		echo "[AWS-Secgame] Using whitelisted IP address. You will not be able to connect to the infrastructure if you do not have this IP address."
	elif [[ "$ans" == "r" ]] || [[ "$ans" == "replace" ]]
	then
		echo "[AWS-Secgame] Using fetched IP address."
		export USER_IP=$test_ip
	else
		echo "[AWS-Secgame] Aborting. Run /config.sh to configurate IP automatically, or edit whitelist.txt yourself."
		exit 2
	fi
fi

#Check whether the provided user profile is valid, i.e. if it is not mistyped.
aws --profile "$SECGAME_USER_PROFILE" sts get-caller-identity > /dev/null 2>&1
if [[ $? -ne 0 ]]
then
	echo "[AWS-Secgame] Unable to confirm validity of AWS keys, please make sure you configured the correct profile."
	exit 2
fi

#Check whether the user has terraform
export terraform_path=$(command -v terraform)
if [[ "$terraform_path" == "" ]]
then
	echo "[AWS-Secgame] Cannot locate terraform. Please make sure terraform is installed and in a location in your PATH."
	exit 2
fi


############################################################
#                                                          #
#                     MISSION CONTROL                      #
#               ground conrol to major tom                 #
############################################################

if [[ "create" = "$1" ]] #User requests a mission deployment
then
	#Generate unique id for this session (only lowercase and numbers)
	export SECGAME_USER_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 10)
	#Eliminate the trailing slash if needed
	export MISSION=$2
	export c=${MISSION: -1}
	if [[ "$c" = "/" ]]
	then
		export MISSION=${MISSION::-1}
	fi
	#Check that a startup script can be found. If not, assume mistype.
	if [[ ! -e ./$MISSION/$MISSION-deploy.sh ]]
	then
		echo "[AWS-Secgame] Cannot find startup script for mission $MISSION. Please check syntax and reiterate."
		exit 2
	fi
	#Make a mission directory, copy the contents of the resources in it, and get in
	mkdir $MISSION-$SECGAME_USER_ID
	cp -r ./$MISSION/* ./$MISSION-$SECGAME_USER_ID/
	cd $MISSION-$SECGAME_USER_ID
	#Run the mission startup script from the resources folder (may have to change path ultimately)
	source ./$MISSION-deploy.sh

elif [[ "destroy" = "$1" ]] #User requests a mission destruction
then
	#Extract user id from folder
	export folder_name=$2
	#Extract mission name from folder name
	export mission=${folder_name%-*}
	#Export constants for use in destroy script
	export SECGAME_USER_ID=${folder_name##*-}
	#Since this gave me one hell of a headache, if the last / of the folder name remains, remove it.
	export c=${SECGAME_USER_ID: -1}
	if [[ "$c" = "/" ]]
	then
		export SECGAME_USER_ID=${SECGAME_USER_ID::-1}
	fi
	#Check if the folder actually exists
	if [[ ! -e $folder_name ]]
	then
		echo "[AWS-Secgame] Cannot find destroy target. Please make sure you typed the correct folder name."
		exit 2
	fi
	#Check if mission name is legal. If not, assume mistype
	if [[ ! -e ./$mission/$mission-destroy.sh ]]
	then
		echo "[AWS-Secgame] Cannot find destroy script for mission $mission. Please check syntax and reiterate."
		exit 2
	fi
	#Check that the user is not trying to run it on the mission (resource) folder
	if [[ $mission = $SECGAME_USER_ID ]]
	then
		echo "[AWS-Secgame] Invalid session ID, please do not attempt to destroy any folder."
		exit 2
	fi

	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi


	#Move folder into trash folder
	mv $folder_name trash/
	cd trash/$folder_name

	#Run the mission destroy script from the resource folder (path subject to change)
	source $mission-destroy.sh
else #User can't use a keyboard to save their lives
	echo "[AWS-Secgame] Invalid command. Command should either be create or destroy. See ./start.sh help for further information."
	exit 2
fi
