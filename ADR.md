# Architecture Decision Records

## Program

### Why bash?

Short answer: It is fun and I wanted to flex.

Long answer: Python is nice, but bash is less cumbersome (in my modest opinion) and allows for direct integration of the AWS CLI, without having to use a packet and an API.

### Folder architecture

`/help` contains all you need if you ever are stuck. `/help/diagrams` needs to be curated.

`/missions` contain all mission data.

## Deployment

### Terraform vs CloudFormation

I initially started on CloudFormation, in order to exploit the powerful tool that CloudFormer is. CloudFormer is an AWS-maintained architecture-to-code dumper that swallows your whole account and spits you a nice and even CF script.

I found it easy to use in the beginning. However, CF proved capricious both for the user-data (which I found hard to add), and did not involve IAM roles and some other things.

I did not want to use Terraform in the beginning because I could not and did not want to write the script. However, a nice tool called Terraforming (https://github.com/dtan4/terraforming) allows for a similar infrastructure-to-code dump.
I found it easier to use and modify, and here it went. Be it said: Terraforming is not perfect, and for instance, does not handle startup-scripts on itself. You have to add them manually.

Terraform also has a big advantage which I did not find (perhaps I did not look enough) and that is being able to put variables in your code. Thanks to that, I don't have to sed the deployment code each time anyone starts a new mission.

Also: I found that CloudFormation is incredibly silent in terminal (I might have missed the --verbose option but eh), where Terraform keeps you up-to-date on what it is doing, even popping reminders every 10 seconds. I find that this is better, especially for the user that is curretly deploying potentially costy infrastructure on his account and would rather know not everything is being f\*\*\*ed-up.

### Terraform file architecture

Files in each terraform folder are split according to the AWS service they belong to (in the console) (and very uninspiredly, the way CloudGoat does it). 

A nice package called "terraforming" (see https://github.com/dtan4/terraforming) heped me dump the architecture of mission 2, which serves as basis for the one of mission 3.

Comments separate the categories, but they are not very clear. It is my take that terraform's pseudo-yaml in itself is not clear, but that is my problem.

Note: I also separated service accounts from users for readability, but they are all in iam.tf (when existing).

## Missions

Of course, major spoilers in there if you want to discover it all without any help.
On another note: the "legacy" mission diagrams are still avaliable in "diagrams".

### Mission 1

#### Objectives

The initial objective of mission1 was to allow users to dig from a regular webside in order to find the s3 bucket behind, like flaws.cloud challenge 1.

This caused a number of problems. Namely, DNS reservation could not be set-up on-the-fly for users who create and destroy their infrastructure 40 times a day. And it is incredibly costy. (This service is supposed to be free).

Because of this, the beginning of the first mission got cut. Now, you only have to deal with bucket syncing and rollback.

#### Setup

This mission consists of a single bucket and some data. I thought terraform would be heavily overkill for such a deployment (and I might have been wrong; it is possible that I will change it to check).

Update: After a while, I ended up switching this mission to terraform for uniformization reasons.

Legacy: <<<As such, deployment is handled sorely using bash script; aws s3 mb, aws s3 cp, and the s3api commands "set-file-alc" and "set-bucket-acl".
A problem I have encountered is that setting the bucket ACL is not enough to allow users to download files. This requires the big recursive operation with set-file-acl. 

The command is essentially aws s3 lb --recursive piped with set-file-acl, which sets on the entire bucket.>>>

Side notes: 

-The .git is in clear on the bucket, but hidden on a linux due to the dot. Heh. Also, the commits used to be in my name and got changed.

-This challenge does not use the whitelist. Since it's a read-only bucket with no sensible data, I deemed that it was not worth giving a damn. Might go back on it.

Further notes:

-A script exists now to regenerate the s3.tf file based on the current state of the zipped bucket folder. Since there are about 31 items, this was deemed much easier. 

### Mission 2

#### Objectives

This mission has also seen some retcon. The initial deployment was supposed to pop 2-3 instances, and the user would get CLI keys, and scan them. One of them would have SSH keys in the description, in you get, query metadata and bob's your uncle...

This was deemed "unrealistic" by the person advising me, and I admit he is right. 
So, a bastion-server couple was made in its stead. The idea is simple: Get on the bastion through a leaked username-password couple, dig in it and try to find something interesting.

The preferred method is querying meta-data/userdata for the ssh key, but checking user permission allows one to notice that the user is sudoer. For those who would rather hack "traditionally", this works too.

The AWS part is added when you have to exploit instance credentials to find the other instance (excluding if you took the metadata route).

Side note: the user does not know the bastion is a bastion (except in name).

#### Setup

Like all the following ones, this is deployed using Terraform.

I did a singular choice: I would not let terraform handle the keypair, since this requires a public key to be passed. Conversely, I made the keypair before the instance using the AWS CLI, then passed it as parameter to terraform. While this is not very elegant, it works.

Aside from this, all of the instance-specific stuff is handled through meta-data script. This means anything the instance does is hard-coded in the ec2.tf files.

The bastion makes a new user and assigns it the leaked password and sudo rights, then puts the ssh key in a file in ec2-user's dir. It also sed's the sshd_config file to allow for incoming logins with password rather than keyfile.
The server just makes a flag file. That you are supposed to "cat" ;).

### Mission 3

#### Objectives

This mission is actually very close to its design counterpart. It does, however, have subtilities.

Users are given access to an ec2 instance for investigation. It has minimal privileges, but IAM list everywhere. Its privileges are a bit too granular for realism, but this is rather to prevent the user from breaking down anything...

A document informs the user that a snapshot of the instance exists.

The aim of this mission is to get the owner id, use it to look for the snapshot, make a volume from it and mount the volume on the ec2 to investigate it. It allows users to find a flag, and a way to complete the objective: Make an admin key, take down the instance after exfiltring the data.

It has to be duly noted that the snapshot must be mounted while ignoring the filesystem's uuid using a mount option. A conspicuous text file has been placed to remind people of this and prevent them from spending days researching the error message.

#### Setup

This one is a doozy. Terraform is used up to the point of making the VPC and the instance (again the key is handled with bash).

Then, the script has to scp all data (quietly) in the instance, wait a couple seconds in order to get the eventual consistency of the snapshot, then snapshot it, then RE-ssh on it in order to run a "cleanup script" to obfuscate the instance for the user.

A document on how to mount on linux is added on the instance, in order to facilitate this step for users that are not absolute doctors in xfs file systems. Actually, xfs file systems have an unique id, which cannot be changed while mounted, and thus the snapshot and the current partition have the same one.

This makes linux go bonkers when trying to mount the volume made from the snapshot. One work-around would be to change the uuid, but I opted for an instruction to tell linux to ignore it, which allows for the mount.

After this, two entrypoints exist for privilage escalation (PrivEsc). The first one is the ec2's permission to generate a new CLI key for any user, including the admin. The second is the capacity to update a policy (which has a --set-as-default flag that you do not need extra permissions to set), and can be used to set the ec2's profile as admin.

Both of those are easily setup: simply add the permission in the ec2's instance profile. Much easier than the snapshotting mess.

### Mission 4

#### Objectives

This mission was added much later, as a means to fill the hole between mission 3 and 5. A coworker wanted to learn terraform, so I pruned the templates, and we decided together on a scenario. I would later test it.

Security groups are never used or considered in other missions, so they are used here. The user's IP is filtered, and circumventing the security group requires the user to spin up a new EC2 instance and use it as a jump server. The key-pair, subnet, AMI, and so on, can be the same as that of the original instance. My coworker also spun up a web server to show taht users were filtered, and I loved the idea.

Afterwards, another mode of PrivEsc is available by passing a new IAM policy to the original user. The usual admin policy works well, and allows access to a S3 bucket with the flags.

#### Setup

This one is fairly conventional. What ended up being a problem was to spin up the web server, and to give users the correct permissions to allow them to get the informations for the PrivEsc. Terraform ensures the whole deployment, almost no further actions are required. The user is given permissions to list security groups and the like in order to use the provided ones, rather than create a new one. Same goes for the key pair, but it is possible to create a new one if one wishes.

### Big game / Mission 5

#### Objectives

This mission is designed to take around two hours, and take you on a trip about all that you have learned and some, as well as giving a notion of how vertical mobility can be achieved. Vertical mobility is shifting from a set of privileges to a broader set of privilieges, by any means necessary: finding a new user with better permissions, using an EC2's instance profile, and so on. PrivEsc is a form of vertical mobility, in which you keep to a single user, however.

The reward consists in a closure of scenario, and pictures of my cat. She's cute, isn't she?

#### Setup

The mission could be split in three "layers". From the bottom-up, these are:

Layer 3: the super-secret objective bucket, the DynamoDB containing the admin access keys, its handler, the security server and the lambda that monitors it.

Layer 2: the whole honey-pot group, i.e. the honey-pot itself, the lambda watching it, the mail server.

Layer 1: the ingress. The first keys, and either the generation of the second ones, or the EC2 SSRF to access the second user's personal bucket.

Layer 1 has you use keys with the least possible privileges: a meager describe-instances at best, and slowly, you edge towards better privileges: the layer 2, with permissions on the honeypot lambda, finding ssh keys, accessing the mail server, until you manage to isolate the required attack, prepare it, and privesc to layer 3. Layer 3 has you learn some commands (notably logs and dynamodb), and the flag, but is essentially easier than layer 2. Layer 2 is the beef of this mission.

#### Architecture choices

For the password database, it was originally planned to use a RDS - MySQL database. This decision had a couple of strong points: First, the user had to look for a good old user/password tuple instead of the aws_key/aws_secret_key you got used to during the entire game. Another point was that you would have to access MySQL through the command line, and run your queries in SQL, which, in itself, is a learning experience, and a challenge.

MySQL suffers from some terrible flaws though. The fact that, when you attempt to deploy a RDS database, you need to deploy what can only be called a f\*\*k-ton of resources, i.e. the RDS, two subnets, a subnet group, another SG just for it, yada, yada. The second and most critical is that this process took ten (10) minutes to be ran through on terraform. The delay was deemed unacceptable.

Such delay could have been complensated by using PostGreSQL instead of MySQL, dropping the delay to around 3 minutes. However, installing a PostGreSQL client on a linux shell is an ordeal I would wish on no one. As such, it was decided to opt for a managed database service, and more specifically for DynamoDB.

DynamoDB, after all, is a good choice for this application. First, it is non-relational and thus can bring you out of your comfort zone a little. Next, it also uses aws commands, which require no further tool to access, and last but not least, it is blazingly fast to deploy. The averse effect was that I had to find a way to give the user AWS keys instead of a username and a password. This is why the "DynamoDB handler" EC2 instance exists. The password allows you to access it, and it is cleared to access DynamoDB only. Still, better to deploy another EC2 than a RDS. Note that you can also use ec2-instance-connect, but you are not told so. 

For the mail server, it was decided to create a /mail in the root of a simple linux system, rather than attempting a realistic mail server. Available clients were also greatly reduced so as not to make the search long and potentially tedious.

It became a problem to track when and how the second user triggered the honey-pot. Initially, I wanted the user to ssh into it to trigger the lambda, but that would have required CloudTrail trails on the user, which are not necessarily free. Thus, I elected to change this to "taking down the instance", and hard coded the user name in the lambda. Not as realistic, but at least it's free.

The mail server has an obvious bait in order to give visibility: the "NEW! Connect NOW with EC2-INSTANCE-CONNECT!" tag on the server. Since it is full of valuable information, it is recommended to go check it.

Checking the lambdas, attempting to download the correct one, that has to be inferred. However, you can check the lambda role policy in order to find the group you can assign to yourself.

Back in layer 1, you can either directly generate keys to access layer 2, which is easy mode but not obvious, or you can do the ec2 ssrf. This means cURLing the proxy with parameter ?url=169.254.169.254 and fiddle around in the meta-data until you find the iam keys. Then, set them, and read the bucket to get your real layer 2 credentials.

### Scenario

Honestly if you need an ADR on that you are a nitpicker.

More seriously, this is a security game. It made sense that you'd be in a situation akin to a security engineer, but an ethical hacker is a much more seductive prospect, isn't it?

### Flags

Initially, flags were just supposed to be "you win". After a while, we added cats. A lot. And strings you could paste in flagchecker.sh.x to check them. For base64 flags, you may choose to decode them or not.

Note that flagchecker.sh.x is a shell script compiled with shc -r. It should work on any linux system.
