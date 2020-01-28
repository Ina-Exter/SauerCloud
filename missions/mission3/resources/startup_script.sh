#!/bin/bash

echo "
Bob, you big great pillock,

Try to act like you did not forge your IT certification, and setup this extremely critical data server. It contains key data for our future world domination plan using pictures of fat cats (codename CH0-NK3R5) to brainwash the people.
So yeah, this is important. Make it SAFE. The data here should STAY HERE. The server should STAY UP and not be a COMPLETE AND TOTAL CYBER-CHEESE WITH HOLES IN IT.
I hope I impressed upon you why you should not f*** this up. If you do I'll have your hide for dinner.

Yours sincerely, 
IT.

PS: Just in case, remember to set the policies correctly, and in case you lock yourself out, you can regenerate an admin key. DO NOT LEAVE THIS PERMISSION ON!" >> bob_todo.txt

echo "
An EC2 EBS disk is usually an xfs partition.
When a snapshot is made, it needs to be built into either an image, or a volume in order to be used.
You start a new EC2 with an image, or attach a volume to an existing EC2 and give it a name (for instance, /dev/sdh. In this instance, you will want to mount /dev/xvdh1).

An xfs partition has a unique uuid that serves to prevent users from mounting the same filesystem twice. This may sometimes cause superblock problems, especially when mounting a snapshot on the same instance.
To circumvent this, mount has a -o nouuid option that allows users to still mount the filesystem.
Remember to specify that the filesystem is xfs with -t xfs.

Now you know the basics! Go out there and be evil!" >> mounting_on_linux_for_evil_dummies.txt

