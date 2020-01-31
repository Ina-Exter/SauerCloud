import json
import boto3

#WORK IN PROGRESS
def handler(event, context):
    print('Skidaddle skidoodle your dick is now a noodle.')
    iam = boto3.resource('iam')
    group = iam.Group('standard-$SAUERCLOUD_USER_ID')
    response = group.remove_user(UserName='emmyselly-$SAUERCLOUD_USER_ID')
    print(response)
    group = iam.Group('suspect-$SAUERCLOUD_USER_ID')
    response = group.add_user(UserName='emmyselly-$SAUERCLOUD_USER_ID')
    print(response)
    return {
        'statusCode': 200,
        'body': json.dumps('Finishing transmission.')
    }

