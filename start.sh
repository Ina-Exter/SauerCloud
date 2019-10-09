#!/bin/bash

############################################################
#                                                          #
#              AWS OFFENSIVE SECURITY GAME                 #
#                         About                            #
############################################################

#This security game is initially developed for internal use 
#by society Stack Labs. Its future uses are not limited to 
#this and should not be considered a company exclusivity.

#These scripts and most of the ressources were made by
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
	echo "[AWS-Secgame] This text is helpful." #work in progress, insert more coffee
	exit 2
fi

#If user failed a configuration step, kindly remind him to go do it
if [ ! -e profile ] || [ ! -e whitelist ]
then
	echo "[AWS-Secgame] Please configure your default profile and whitelist ip before starting missions. Run ./config in order to write these files."
	exit 2
fi

#If user wrote more than 2 arguments, or less than 2 (excluding the one case with just "help", explain the error.
if [[ 2 -ne "$#" ]]
then
	echo -n "[AWS-Secgame] Illegal argument error. start.sh requires exactly 2 arguments."
	echo " Supplied $# argument(s)."
	echo "[AWS-Secgame] Structure: ./start.sh command mission"
	echo "[AWS-Secgame] Command is either create or destroy."
	echo "[AWS-Secgame] Mission is either mission1, mission2, ... for create, or the mission folder for destroy."
	exit 2
fi

#TODO: MAKE SURE USER HAS TERRAFORM

############################################################
#                                                          #
#                  ENVIRONMENT HANDLING                    #
#                                                          #
############################################################

#Load environment variables from files profile and whitelist
export SECGAME_USER_PROFILE=$(head -n 1 profile)
export USER_IP=$(head -n 1 whitelist)


############################################################
#                                                          #
#                     MISSION CONTROL                      #
#               ground conrol to major tom                 #
############################################################

if [[ "create" = "$1" ]] #User requests a mission deployment
then
	#Generate unique id for this session (only lowercase and numbers)
	export SECGAME_USER_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 10)
	#Check that a startup script can be found. If not, assume mistype.
	if [[ ! -e ./$2/$2-deploy.sh ]]
	then
		echo "[AWS-Secgame] Cannot find startup script for mission $2. Please check syntax and reiterate."
		exit 2
	fi
	#Make a mission directory, copy the contents of the ressources in it, and get in
	mkdir $2-$SECGAME_USER_ID
	cp -r ./$2/* ./$2-$SECGAME_USER_ID/
	cd $2-$SECGAME_USER_ID
	#Run the mission startup script from the ressources folder (may have to change path ultimately)
	source ./$2-deploy.sh

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
	if [[ $c = "/" ]]
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
	#Check that the user is not trying to run it on the mission (ressource) folder
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

	#Run the mission destroy script from the ressource folder (path subject to change)
	source $mission-destroy.sh
else #User can't use a keyboard to save their lives
	echo "[AWS-Secgame] Invalid command. Command should either be create or destroy. See ./start.sh help for further information."
	exit 2
fi
