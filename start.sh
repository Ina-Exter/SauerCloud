#!/bin/bash

if [[ $# -ne 2 ]]
then
	exit
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
