#!/bin/bash

cat <<END> lambda-change-group.py
import json
import boto3

def handler(event, context):
    print('Suspicious behaviour detected. Switching off permissions before further investigation.')
    iam = boto3.resource('iam')
    group = iam.Group('standard-$SAUERCLOUD_USER_ID')
    print('Group removal:')
    response = group.remove_user(UserName='emmyselly-$SAUERCLOUD_USER_ID')
    print(response)
    group = iam.Group('suspects-$SAUERCLOUD_USER_ID')
    print('Group addition:')
    response = group.add_user(UserName='emmyselly-$SAUERCLOUD_USER_ID')
    print(response)
    return {
        'statusCode': 200,
        'body': json.dumps('')
    }
END
