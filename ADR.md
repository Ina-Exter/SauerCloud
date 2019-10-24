# Architecture Decision Records

## Program

### Why bash?

Short answer: It is fun and I wanted to flex.

Long answer: Python is nice, but bash is less cumbersome (in my modest opinion) and allows for direct integration of the AWS CLI, without having to use a packet and an API.

### Folder architecture

SUBJECT TO CHANGE!!!!1!!1!!1!ONE!

## Deployment

### Terraform vs CloudFormation

I initially started on CloudFormation, in order to exploit the powerful tool that CloudFormer is. CloudFormer is an AWS-maintained architecture-to-code dumper that swallows your whole account and spits you a nice and even CF script.

I found it easy to use in the beginning. However, CF proved capricious both for the user-data (which I found hard to add), and did not involve IAM roles and some other things.

I did not want to use Terraform in the beginning because I could not and did not want to write the script. However, a nice tool called Terraforming (https://github.com/dtan4/terraforming) allows for a similar infrastructure-to-code dump.
I found it easier to use and modify, and here it went. Be it said: Terraforming is not perfect, and for instance, does not handle startup-scripts on itself. You have to add them manually.

Terraform also has a big advantage which I did not find (perhaps I did not look enough) and that is being able to put variables in your code. Thanks to that, I don't have to sed the deployment code each time anyone starts a new mission.

Also: I found that CloudFormation is incredibly silent in terminal (I might have missed the --verbose option but eh), where Terraform keeps you up-to-date on what it is doing, even popping reminders every 10 seconds. I find that this is better, especially for the user that is curretly deploying potentially costy infrastructure on his account and would rather know not everything is being f\*\*\*ed-up.

### Terraform file architecture

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

Because of this, the beginning of the first mission got cut. Now, you only have to deal with bucket rollback.

#### Setup

This mission consists of a single bucket and some data. I thought terraform would be heavily overkill for such a deployment (and I might have been wrong; it is possible that I will change it to check).

As such, deployment is handled sorely using bash script; aws s3 mb, aws s3 cp, and the s3api commands "set-file-alc" and "set-bucket-acl".
A problem I have encountered is that setting the bucket ACL is not enough to allow users to download files. This requires the big recursive operation with set-file-acl. 

The command is essentially aws s3 lb --recursive piped with set-file-acl, which sets on the entire bucket.

Side notes: 

-The .git is in clear on the bucket, but hidden on a linux due to the dot. Heh. Also, the commits are in my name and should/might be changed.

-This challenge does not use the whitelist. Since it's a read-only bucket with no sensible data, I deemed that it was not worth giving a damn. Might go back on it.

### Mission 2

#### Objectives

This mission has also seen some retcon. The initial deployment was supposed to pop 2-3 instances, and the user would get CLI keys, and scan them. One of them would have SSH keys in the description, in you get, query metadata and bob's your uncle...

This was deemed "unrealistic" by the person advising me, and I admit he is right. 
So, a bastion-server couple was made in its stead. The idea is simple: Get on the bastion through a leaked username-password couple, dig in it and try to find something interesting.

The preferred method is querying meta-data/userdata for the ssh key, but checking user permission allows one to notice that the user is sudoer. For those who would rather hack "traditionally", this works too.

The AWS part is added when you have to exploit instance credentials to find the other instance (excluding if you took the metadata route).

Side note: the user does not know the bastion is a bastion (except in name).

#### Setup

Like all the following ones (most likely), this is deployed using Terraform.

I did a singular choice: I would not let terraform handle the keypair, since this requires a public key to be passed. Conversely, I made the keypair before the instance using the AWS CLI, then passed it as parameter to terraform. While this is not very elegant, it is functionnal.

Aside from this, all of the instance-specific stuff is handled through meta-data script. This means anything the instance does is hard-coded in the ec2.tf files.

The bastion makes a new user and assigns it the leaked password and sudo rights, then puts the ssh key in a file in ec2-user's dir. It also sed's the sshd_config file to allow for incoming logins with password rather than keyfile.
The server just makes a flag file. That you are supposed to "cat" ;).

### Mission 3

#### Objectives

This mission is actually very close to its design counterpart. It does, however, have subtilities.

Users are given access to an ec2 instance for investigation. It has minimal privileges, but IAM list everywhere. Its privileges are a bit too granular for realism, but this is rather to prevent the user from breaking down anything...

A document informs the user that a snapshot of the instance exists.

The aim of this mission is to get the owner id, use it to look for the snapshot, make a volume from it and mount the volume on the ec2 to investigate it. It allows users to find a flag, and a way to complete the objective: Make an admin key, take down the instance after exfiltring the data.

#### Setup

This one is a doozy. Terraform is used up to the point of making the VPC and the instance (again the key is handled with bash).

Then, the script has to scp all data (quietly) in the instance, wait a couple seconds in order to get the eventual consistency of the snapshot, then snapshot it, then RE-ssh on it in order to run a "cleanup script" to obfuscate the instance for the user.

A document on how to mount on linux is added on the instance, in order to facilitate this step for users that are not absolute doctors in xfs file systems. Actually, xfs file systems have an unique id, which cannot be changed while mounted, and thus the snapshot and the current partition have the same one.

This makes linux go bonkers when trying to mount the volume made from the snapshot. One work-around would be to change the uuid, but I opted for an instruction to tell linux to ignore it, which allows for the mount.

After this, two entrypoints exist for privilage escalation (PrivEsc). The first one is the ec2's permission to generate a new CLI key for any user, including the admin. The second is the capacity to update a policy (which has a --set-as-default flag that you do not need extra permissions to set), and can be used to set the ec2's profile as admin.

Both of those are easily setup: simply add the permission in the ec2's instance profile. Much easier than the snapshotting mess.

### Big game

### Scenario

Honestly if you need an ADR on that you are a nitpicker (and you just lost The Game).

More seriously, this is a security game. It made sense that you'd be in a situation akin to a security engineer, but an ethical hacker is a much more seductive prospect, isn't it?
