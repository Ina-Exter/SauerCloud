#!/bin/bash

if [[ "$1" = "help" ]]
then
	echo "This text is helpful."
	exit 2
fi
if [[ 2 -ne "$#" ]]
then
	echo -n "Illegal argument error. start.sh requires exactly 2 arguments."
	echo " Supplied $# argument(s)."
	echo "Structure: ./start.sh command mission"
	echo "Command is either create or destroy."
	echo "Mission is either mission1, mission2, ... for create, or the mission folder for destroy."
	exit 2
fi
## $1 is first argument, $2 is second


############################################################
#                                                          #
#                  ENVIRONMENT HANDLING                    #
#                                                          #
############################################################

##Load environment variables
export SECGAME_USER_PROFILE=$(head -n 1 profile)
export USER_IP=$(head -n 1 whitelist)


############################################################
#                                                          #
#                     MISSION STARTUP                      #
#                                                          #
############################################################

if [[ "create" = "$1" ]]
then
	##Generate unique id for this session
	export SECGAME_USER_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 10)
	mkdir $2-$SECGAME_USER_ID
	cd $2-$SECGAME_USER_ID
	source ./../$2/$2-deploy.sh
elif [[ "destroy" = "$1" ]]
then
	##Extract user id from folder
	export folder_name=$2
	export mission=${folder_name%-*}
	export SECGAME_USER_ID=${folder_name##*-}
	source ./$mission/$mission-destroy.sh
else
	echo "Invalid command. Command should either be create or destroy. See ./start.sh help for further information."
	exit 2
fi
