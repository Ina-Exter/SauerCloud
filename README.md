# AWS Offensive Security Game

**A tool for deploying vulnerable-by-design infrastructure on your personal AWS account for penetration testing purposes.**

## What you need

* Linux operating system. The software has not been tested on MacOS and I doubt it can work on Windows. WSL should be fine but untested.
* Bash and the following binaries, always in your path:
  * ssh
  * scp
  * unzip
  * zip
  * The AWS cli
  * terraform v0.12

## Quick Start Guide

Pull the repository and change to the 
You need to configure your default profile and IP address for the program to work properly. For this, run:

`./config.sh`

and follow the instructions. Once this is done, any mission can be started using:

`./start.sh create missionX`

A briefing will be displayed. You can find relevant files in the `missionX-id` directory that will be created (the id is a 10-character random string). You may use only what can be found in this directory, and **not in the subdirectories, nor may you use your "profile" access keys.**
If you need help, cheat sheets are available in the `/help/cheat-sheets/` folder.

Once you are done, destroy your infrastructure with:

`./start.sh destroy missionX-id`

Remember to delete resources you created yourself before that. Terraform will not handle them and will most likely be very distressed at the prospect.

## FAQ

### What is this?

This program is a deployment framework made to allow users to deploy vulnerable-by-design AWS infrastructures on their own private account, and penetration-test it in a secure fashion.

The aim is to teach users about both penetration testing (pen-test for short), and raise awareness about the mess and dire consequences that may be caused by misconfigurations, if they are spotted by an ill-intentionned person.

Most of the time, there are one (or two) go-to ways to go through each mission, but if you find another, good for you! It's a "feature".

### Who made it?


### Inspirations

The programmer would like to thank CloudGoat (by RhinoSecurityLabs) and flaws.cloud. This is a free inspiration of their work, technically devoid of plagiarism.
Those two also make great learning resources and I recommand them warmly.

### How do I use it?

First of all, this will require, for CLI access reasons, either MacOS or Linux. For now, it remains untested on MacOS, so Linux. Also, you will need the AWS CLI installed and access keys with sufficient privileges to create and destroy IAM, EC2, S3, RDS and Lambda resources.

Provided you already have an AWS account and the associated CLI keys, read this section.
If you have no idea what I just told you means, don't panic and look at the next section.



In order to start using this software, first run ./config.sh in order to make "profile" and "whitelist" files. Your ip is whitelisted in order to avoid someone else haphazardly getting into your account through a vulnerable app, that'd be ironic.

Then, you may start any mission using start.sh **(file name subject to change)**.

Syntax:
>./start.sh <command> argument

Commands: 

At the moment, three are available

* help

This command does not take an argument. It will display a brief helptext to the user, then exit gracefully.

* create

Create is the go-to command to start a mission. It will generate everything you need for a new mission, them prompt the user for confirmation. Should it not be given, the program will delete anything it made.

Legal arguments include:

  >* mission1

  >* mission2

  >* mission3

  >* mission4

Each will create the associated mission. For more details on missions, consult the "Missions" part in this document, and the ADR.md document.

* destroy

Destroy takes a mission folder as argument (so missionX-id, with or without the trailing slash) and proceeds to ask the user for confirmation before deleting all resources. 

Argument format: mission(number)-(id).

Please note that if you create resources yourself during a mission, the program cannot delete them for you. You will have to remove them manually.


Once you have created a mission, you will be prompted to read the briefing in the newly created mission folder. Then, you are all set.

Nb: Most of the time, using anything else than bash and the CLI is considered cheating. ;) You may also use only what I provide you with, not your own administrator AWS keys.

### What is an AWS account/What is AWS?

This part is oriented towards people who do not really know of cloud computing and are hoping to get started with this program.

Please note, however, that the challenges proposed here may be a bit complex for people who have no idea what they are looking for.

#### What is cloud computing (in a nutshell)?

Paying for servers is expensive. Setting them up is a doozy. It takes room, heats a lot, and you cannot adjust your consumption easily.

AWS (Amazon Web Services) is a cloud computing provider. They "rent" granular pieces of their servers for you to setup VMs across the internet and use them in a way you want, rather than having to buy a server.

This, in turn, gives rise to a host of services hosted "on the cloud" (i.e. on gigantic data centers on some key locations rather than on smaller-but-still-big data centers on premises), but those services may be rendered vulnerable in their own way.
And that "way" usually involves the biggest flaw in the system, usually located between the chair and the screen, i.e. the user.

So in layman's term, this program is an automated way to request virtual machines on a remote AWS server for you to then experiment with trying to break them or break into them. The vulnerabilities you will learn of here are very specialized, and will mostly only work on AWS infrastructure.
Given, however, that AWS has around 70% of the market in cloud computing, and that cloud computing is ever on the rise, knowing how to make appliances secure is a very useful skill.

#### How do I make one?

Go to the website and subscribe. You will be asked for a credit card but should not be charged at first (see next section for details).

After that, you have two means of interacting with your AWS account:

  * Account Console

  * CLI

We will mostly use the CLI. You will have to generate CLI keys to use your account with.
 
#### What are those "CLI keys" you spoke of? Is this Klingon?

CLI stands for command-line-interface. It essentially means you are going to work in a terminal-like environment (sorry Windows Users).

You will need to install AWS' tool for the CLI (aka the AWS CLI). Depending on your distribution, there is most likely a package to get it. For debian or ubuntu users, *sudo apt-get install awscli* should work. Otherwise, you may opt for a Docker image.

Once this is done, you will have to specify your account information so the CLI knows with which account (more specifically, with whose credit card...) it is working. This can be done using the following command:

`aws configure --profile [YOUR_PROFILE_NAME]`

This will request you to input information. In order to get an access key and secret access key, visit the AWS console with a regular internet browser, select "IAM", and create an user **with programmatic access**. Give it sufficient privileges, and in the end you will get both keys.

For the default region, this program currently only supports "us-east-1". For the default output format, I tend to prefer "json", but to each their own.

Once this is configured (remember well your profile name), you should be good to go.

### Will I be charged?

Short answer: No.

Long answer: The AWS Free Tier provides you with a set number of hours of use of a t2-micro over a month. You have 760 monthly hours of free use for the 12 months after your account creation. That amounts roughly to one t2-micro running thorought the month.

If you deploy several instances using this program, or that you leave them running for a period of time, you may exceed this cap (especially with mission 2 or the bigger game), and then you will be charged. Please make sure to destroy your resources systematically.

Disclaimer: I am in no way responsible for any billing occuring as a result of using this software.


