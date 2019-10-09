#!/bin/bash

##Sanity check: print user profile, id, ip
##May delete it afterwards
echo $SECGAME_USER_PROFILE
echo $SECGAME_USER_ID
echo $USER_IP

#Given the extremely light nature of this script, the deployment will be fully handled with bash script and AWS cli, and not with terraform.
#Note that ALL commands are run with --quiet so as to avoid spoiling the user.

#ALWAYS assume that this script will run in the mission folder mission1-user_id

#This first command makes a new bucket called evilcorp-evilbucket-user_id.
aws --profile $SECGAME_USER_PROFILE s3 mb s3://evilcorp-evilbucket-$SECGAME_USER_ID
echo Bucket created

#Imports ressources from the original mission1 folder, and copies them onto the bucket.
aws --profile $SECGAME_USER_PROFILE s3 --quiet cp ./../mission1/ressources/evilcorp-evilbucket-data s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive
echo Ressources copied on bucket

#Sets the bucket's ACL (access control list) to public for maximum vulnerability
aws --profile $SECGAME_USER_PROFILE s3api put-bucket-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID
echo "Bucket ACL set"

#This gets a bit tacky. All files also have to have public access, and I found no better way than to pipe it all together and pray.
#This essentially lists bucket content, then for each, sets ACL as public-read. Since .git folders a a bit large, this may take up to 30 seconds.
echo "Setting file ACL, please wait (expected wait under 1 minute)."
aws --profile $SECGAME_USER_PROFILE s3 ls s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive|awk '{cmd="aws --profile $SECGAME_USER_PROFILE s3api put-object-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID --key "$4; system(cmd)}'
echo "File ACL set"

# A briefing serves as a starting point for the user, now with extra hacky flavour!
touch briefing.txt
echo "Greetings, agent. Our company received strange reports regarding another large-scale, multinational company called EvilCorp \
Word has it that they are plotting something. Something bad. However, our informants have found a lead. \
Our guy working at Amazon Web Services reported seeing the name of Evilcorp passing by in an S3 report. There may be something to see. \
Look up their evilcorp-evilbucket-$SECGAME_USER_PROFILE bucket and try to find out whatever you can." >> briefing.txt

echo "Mission 1 deployment complete. Read the briefing.txt file to begin."
