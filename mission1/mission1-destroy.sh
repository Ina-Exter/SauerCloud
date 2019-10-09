#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#ALWAYS assume this will run from the mission dir!

#Destroy the bucket based on user ID. User ID should be passed by start.sh
echo "[AWS-Secgame] Force-destroying bucket"
aws --profile $SECGAME_USER_PROFILE s3 rb s3://evilcorp-evilbucket-$SECGAME_USER_ID --force

echo "[AWS-Secgame] Mission 1 destroy complete."
