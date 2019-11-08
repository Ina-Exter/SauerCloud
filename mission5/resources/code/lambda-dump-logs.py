import json
#WORK IN PROGRESS
def handler(event, context):
    print('mysql -h hostname -u user -ppassword database')
    print('THIS IS A LOG FOR CLOUDWATCH DAMMIT')
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

