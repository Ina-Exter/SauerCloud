#!/bin/bash

#ALWAYS assume this will run from the PARENT DIRECTORY of the mission dir!

#Destroy the bucket based on user ID. User ID should be passed by start.sh
aws --profile $SECGAME_USER_PROFILE s3 rb s3://evilcorp-evilbucket-$SECGAME_USER_ID --force

echo "Mission 1 destroy complete."
