#!/bin/bash

##Sanity check: print user profile, id, ip
echo $SECGAME_USER_PROFILE
echo $SECGAME_USER_ID
echo $USER_IP

aws --profile $SECGAME_USER_PROFILE s3 mb s3://evilcorp-evilbucket-$SECGAME_USER_ID
echo Bucket created
aws --profile $SECGAME_USER_PROFILE s3 cp ./../mission1/ressources/evilcorp-evilbucket-data s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive
echo Ressources copied on bucket
aws --profile $SECGAME_USER_PROFILE s3api put-bucket-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID
echo "Bucket ACL set"
echo "aws --profile $SECGAME_USER_PROFILE s3 ls s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive|awk '{cmd="aws --profile $SECGAME_USER_PROFILE s3api put-object-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID --key "$4; system(cmd)}'"
aws --profile $SECGAME_USER_PROFILE s3 ls s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive|awk '{cmd="aws --profile $SECGAME_USER_PROFILE s3api put-object-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID --key "$4; system(cmd)}'
echo "File ACL set"

touch briefing.txt

echo "Greetings, agent. Our company received strange reports regarding another large-scale, multinational company called EvilCorp \
Word has it that they are plotting something. Something bad. However, our informants have found a lead. \
Look up their website, https://evilcorp.com and try to find out whatever you can." >> briefing.txt

echo "Mission 1 deployment complete. Read the briefing.txt file to begin."
