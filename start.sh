#!/bin/bash

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
##Generate unique id for this session
export SECGAME_USER_ID=$(head /dev/urandom | tr -dc a-z0-9 | head -c 10)


############################################################
#                                                          #
#                     MISSION SELECT                       #
#                                                          #
############################################################

##For now, auto start mission 1
mkdir mission1-$SECGAME_USER_ID
cd mission1-$SECGAME_USER_ID
source ./../mission1/mission1-deploy.sh
