#!/bin/bash

#These scripts and most of the resources were made by
#Xavier Goffin (xaviergoffin42@gmail.com, xavier.goffin@stack-labs.com)
#I am not responsible for any billing charges incurred when using this program.

############################################################
#                                                          #
#                      SANITY CHECKS                       #
#                                                          #
############################################################

#If user requests help, do not send him packing
if [[ "$1" = "help" ]]; 
then
       cat <<HELP
############################################################
#                                                          #
#              AWS OFFENSIVE SECURITY GAME                 #
#                    About and help                        #
############################################################

[AWS-Secgame] AWS-Secgame (name subject to change) is a bash-and-terraform deployment framework in order to setup "nice" and "fun" challenges to sensbilize to AWS vulnerabilities caused by misconfigurations.

SYNTAX   
	start.sh <command> argument

COMMANDS 

	help

		This command does not take an argument. It will display a brief helptext to the user, then exit gracefully.

	create

		Create is the go-to command to start a mission. It will generate everything you need for a new mission, them prompt the user for confirmation. Should it not be given, the program will delete anything it made.

		Legal arguments include:

	  	> mission1

		> mission2

		> mission3

		> mission4

		> mission5

		Each will create the associated mission. For more details on missions, consult the "Missions" part in this document, and the ADR.md document.

		Example: ./start.sh create mission1

	destroy

		Destroy takes a mission folder as argument (so missionX-id, with or without the trailing slash) and proceeds to ask the user for confirmation before deleting all resources. 

		Argument format: mission(number)-(id).

		Please note that if you create resources yourself during a mission, the program cannot delete them for you. You will have to remove them manually.

		Example: ./start.sh destroy mission1-aaaaaaaaaa
HELP
       exit 1
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
SECGAME_USER_PROFILE=$(head -n 1 profile.txt)
export SECGAME_USER_PROFILE
USER_IP=$(head -n 1 whitelist.txt)
export USER_IP

#Display warning regarding IP
test_ip=$(curl icanhazip.com --silent)

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
if ! aws --profile "$SECGAME_USER_PROFILE" sts get-caller-identity > /dev/null 2>&1
then
	echo "[AWS-Secgame] Unable to confirm validity of AWS keys, please make sure you configured the correct profile."
	exit 2
fi

#Check whether the user has terraform
terraform_path=$(command -v terraform)
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
	SECGAME_USER_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 10)
	export SECGAME_USER_ID
	#Eliminate the trailing slash if needed
	MISSION=$2
	c=${MISSION: -1}
	if [[ "$c" = "/" ]]
	then
		MISSION=${MISSION::-1}
	fi
	#Check that a startup script can be found. If not, assume mistype.
	if [[ ! -e ./$MISSION/$MISSION-deploy.sh ]]
	then
		echo "[AWS-Secgame] Cannot find startup script for mission $MISSION. Please check syntax and reiterate."
		exit 2
	fi
	#Make a mission directory, copy the contents of the resources in it, and get in
	mkdir "$MISSION"-"$SECGAME_USER_ID"
	cp -r ./"$MISSION"/* ./"$MISSION"-"$SECGAME_USER_ID"/
	cd "$MISSION"-"$SECGAME_USER_ID" || exit
	#Run the mission startup script from the resources folder (may have to change path ultimately)
	# shellcheck disable=SC1090
	source ./"$MISSION-deploy.sh"

elif [[ "destroy" = "$1" ]] #User requests a mission destruction
then
	#Extract user id from folder
	folder_name=$2
	#Extract mission name from folder name
	mission=${folder_name%-*}
	#Export constants for use in destroy script
	export SECGAME_USER_ID=${folder_name##*-}
	#Since this gave me one hell of a headache, if the last / of the folder name remains, remove it.
	c=${SECGAME_USER_ID: -1}
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
	if [[ "$mission" = "$SECGAME_USER_ID" ]]
	then
		echo "[AWS-Secgame] Invalid session ID, please do not attempt to destroy any folder."
		echo "[AWS-Secgame] Destroy structure is ./start.sh destroy missionX-aaaaaaaaaa."
		exit 2
	fi

	#If trash doesn't exist, make it
	if [[ ! -d "trash" ]]
	then
        	mkdir trash
	fi


	#Move folder into trash folder
	mv "$folder_name" trash/
	cd "trash/$folder_name" || exit

	#Run the mission destroy script from the resource folder (path subject to change)
	# shellcheck disable=SC1090
	source "$mission-destroy.sh"
else #User can't use a keyboard to save their lives
	echo "[AWS-Secgame] Invalid command. Command should either be create or destroy. See ./start.sh help for further information."
	exit 2
fi
