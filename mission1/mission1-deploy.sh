#!/bin/bash

export SECGAME_USER_PROFILE=altaccount
export SECGAME_USER_ID=azdvargze

aws --profile $SECGAME_USER_PROFILE s3 mb s3://evilcorp-evilbucket-$SECGAME_USER_ID
aws --profile $SECGAME_USER_PROFILE s3 cp ./ressources/evilcorp-evilbucket-data s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive
aws --profile $SECGAME_USER_PROFILE s3api put-bucket-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID
aws --profile $SECGAME_USER_PROFILE s3 ls s3://evilcorp-evilbucket-$SECGAME_USER_ID --recursive | awk '{cmd="aws --profile $SECGAME_USER_PROFILE s3api put-object-acl --acl public-read --bucket evilcorp-evilbucket-$SECGAME_USER_ID --key "$4; system(cmd)}'
echo Deployment complete
