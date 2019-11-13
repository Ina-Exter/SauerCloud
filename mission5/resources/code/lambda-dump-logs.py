import json
#WORK IN PROGRESS
def handler(event, context):
    print('Unexpected termination of dynamo handler instance, dumping logs for post-mortem.')
    print('testestwololoyolo')
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

