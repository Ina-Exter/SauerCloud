# Mission 3 cheat sheet


This mission serves to introduce users to snapshots, EBS volumes and mounting.


  * Given: Instance ip, SSH key
  * Variables: $id, $instance_ip


$ `ssh -i ssh_key.pem ec2-user@$instance_ip`

Log into the instance to look around.


$ `aws --region us-east-1 ec2 describe-instances`

Find the current instance id, and the account owner id.
These will now be called $instance_id and $owner_id respectively.


$ `aws --region us-east-1 ec2 describe-snapshots --owner-id $owner_id`

List the snapshots currently owned by the account.
There is one snapshot. Its id will be called $snapshot_id


$ `aws --region us-east-1 ec2 create-volume --availability-zone us-east-1a --snapshot-id $snapshot_id`

Create an EBS volume using this snapshot. Its id is called $ebs_id.


## Route 1: Mount the volume on the current instance

$ `aws --region us-east-1 ec2 attach-volume --device sdh --volume-id $ebs_id --instance-id $instance_id`

Attach the newly made volume to the instance. Here, it is attached as sdh, and the rest of the instructions will consider that you attached it as sdh as well.


$ `sudo su; mount -t xfs -o nouuid /dev/xvdh1 /mnt`

Only root can use -o options on mount, so switch to root. Mount xvdh1 (partition of sdh) on /mnt while specifying the filesystem type (xfs) and avoiding uuid checks (-o nouuid). This is required since both volumes are actually the same at different points in time, so their uuid are the same.


## Route 2: Create a new instance and mount the volume there

$ `aws --region us-east-1 ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn-ami-hvm-????.??.?.????????-x86_64-gp2' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text`

Find the latest Amazon Linux AMI, called $ami_id afterwards. Note that you can also use that of the other instance by describing it.
This command is not really something to know. [AWS displays it openly on their help website.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-an-ami-parameter-store)


$ `aws --region us-east-1 ec2 describe-instances`

Find the name of the key-pair this instance is using, called $key_pair from now on. Also note the security group id, called $sg_id


$ `aws --region us-east-1 ec2 run-instances --image-id $ami_id --key-name $key_pair --security-group-ids $sg_id`

Start a new instances with parameters that allow you to access it. Amazon Linux is chosen here, but you can use whichever. Note the new instance id as $new_instance_id.


$ `aws --region us-east-1 ec2 attach-volume --device sdh --volume-id $ebs_id --instance-id $new_instance_id`

Attach the volume to the new instance.


$ `ssh -i ssh_key.pem ec2-user@<private ip of new instance>`

Access the new instance. You may have to fetch ssh_key.pem from your own terminal.


$ `mount -t xfs /dev/xvdh1 /mnt`

Mount xvdh1 (partition of sdh) on /mnt while specifying the filesystem type (xfs).


## With the volume mounted

$ `cd mnt/home/ec2-user; ls; cd chonks; cat flag.txt`

You win! Note that the instance has the required privileges to generate administrator AWS keys...


## Remember

**Delete anything you created before attempting to destroy the mission. This includes volumes, instances, and so on. The snapshot is destroyed by the script, so do not worry about that.**