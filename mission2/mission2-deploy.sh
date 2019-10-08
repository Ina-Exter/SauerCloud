#!/bin/bash

#User wants to deploy mission 2. A ssh private key should also be generated and passed as parameter.
export AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID=$(aws --profile $SECGAME_USER_PROFILE ec2 create-key-pair --key-name AWS-secgame-mission2-keypair-Evilcorp-Evilkeypair-$SECGAME_USER_ID --query 'KeyMaterial' --output text)

#Consider saving the private key juuuuuuuuuust in case.

#Initialize terraform (in the relevant dir?) (cp to local dir?)

#Pass the required variables (profile, region?, id, key) to terraform

#Plan

#IF AND ONLY IF user consents, deploy

#Check that everything went smoothly (enough)

#Write briefing

#???

#profit

echo "Deploy complete"
