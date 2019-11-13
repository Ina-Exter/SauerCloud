import json
#WORK IN PROGRESS
def handler(event, context):
    print('Unexpected termination of dynamo handler instance detected, dumping logs for post-mortem.')
    print('|20XX/09/17| Startup of EC2-instance "ddb-handler".')
    print('|20XX/09/17| Startup of key-registration logging service.')
    print('|20XX/09/18| Port of RDS-evil-password-database on ddb-AWSkeys through ddb-handler.')
    print('|20XX/10/10| Offline for maintenance.')
    print('|20XX/10/13| Changing access method to password in order to allow management to check the database.')
    print('|20XX/10/13| sudo chpasswd "ec2-user:foobarbazevil"')
    print('|20XX/10/13| Please remember to switch back to ssh key access afterwards...')
    print('|20XX/11/01| Bob accessed ddb-handler.')
    print('|20XX/11/02| 3v1l-m4n4ger accessed ddb-handler.')

    return {
        'statusCode': 200,
        'body': json.dumps('Finishing transmission.')
    }

