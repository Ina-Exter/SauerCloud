#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo "[AWS-Secgame] Master account profile: $SECGAME_USER_PROFILE"
echo "[AWS-Secgame] Session ID: $SECGAME_USER_ID"
echo "[AWS-Secgame] User IP: $USER_IP"

#Given the extremely light nature of this script, the deployment will be fully handled with bash script and AWS cli, and not with terraform.
#Note that ALL commands are run with --quiet so as to avoid spoiling the user.

#ALWAYS assume that this script will run in the mission folder mission1-user_id

#This first command makes a new bucket called evilcorp-evilbucket-user_id.
aws --profile $SECGAME_USER_PROFILE s3 mb s3://evilcorp-evilbucket-$SECGAME_USER_ID
echo "[AWS-Secgame] Bucket created"

#Imports ressources from the original mission1 folder, and copies them onto the bucket.
aws --profile $SECGAME_USER_PROFILE s3 --quiet cp ./../mission1/ressources/evilcorp-evilbucket-data s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive
echo "[AWS-Secgame] Ressources copied on bucket"

#Sets the bucket's ACL (access control list) to public for maximum vulnerability
aws --profile $SECGAME_USER_PROFILE s3api put-bucket-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID
echo "[AWS-Secgame] Bucket ACL set"

#This gets a bit tacky. All files also have to have public access, and I found no better way than to pipe it all together and pray.
#This essentially lists bucket content, then for each, sets ACL as public-read. Since .git folders a a bit large, this may take up to 30 seconds.
echo "Setting file ACL, please wait (expected wait under 1 minute)."
aws --profile $SECGAME_USER_PROFILE s3 ls s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive|awk '{cmd="aws --profile $SECGAME_USER_PROFILE s3api put-object-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID --key "$4; system(cmd)}'
echo "[AWS-Secgame] File ACL set"

# A briefing serves as a starting point for the user, now with extra hacky flavour!
touch briefing.txt
echo "Greetings, agent. Our company received strange reports regarding another large-scale, multinational company called EvilCorp \
Word has it that they are plotting something. Something bad. However, our informants have found a lead. \
Our guy working at Amazon Web Services reported seeing the name of Evilcorp passing by in an S3 report. There may be something to see. \
Look up their evilcorp-evilbucket-$SECGAME_USER_PROFILE bucket. There should be interesting files on there, and a hint regarding their plans..." >> briefing.txt

echo "[AWS-Secgame] Mission 1 deployment complete. Mission folder is ./mission1-$SECGAME_USER_ID. Read the briefing.txt file to begin."
