# Mission 5 cheat sheet


This mission lets users manipulate new EC2 instances in order to become more familiar with security groups, and has a small IAM component.


  * Given: AWS key, AWS secret key, ssh key
  * Variables: $id


$ `aws configure --profile juan`

Set up the credentials for use. Region is always us-east-1 and json output is recommended.


$ `aws --profile juan ec2 describe-instances`

List the existing instances, since it is not possible to list existing s3 buckets. Note the public and private ip addresses as $public_ip and $private_ip. Note the keypair used as $keypair. You may also want to take note of the AMI used, as $ami_id, and the subnet as  $subnet_id.