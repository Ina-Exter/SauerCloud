#!/bin/bash

aws --profile $SECGAME_USER_PROFILE s3 rb s3://evilcorp-evilbucket-$SECGAME_USER_ID --force

cd ..
if [[ ! -d "trash" ]]
then
	mkdir trash
fi
mv ./mission1-$SECGAME_USER_ID ./trash/

echo "Mission 1 destroy complete."
