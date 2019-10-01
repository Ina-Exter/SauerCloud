#!/bin/bash

export SECGAME_USER_PROFILE=altaccount
export SECGAME_USER_ID=azdvargze

aws --profile $SECGAME_USER_PROFILE s3 rb s3://evilcorp-evilbucket-$SECGAME_USER_ID --force

echo "Destroy complete"
