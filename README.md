#AWS Offensive Security Game

**DISCLAMER: DO NOT USE THESE IN PRODUCTION, THEY ARE VULNERABLE BY DESIGN!**

##FAQ

###What is this?

This program is a deployment framework made to allow users to deploy vulnerable-by-design AWS infrastructures on their own private account, and penetration-test it in a secure fashion.

The aim is to teach users about both penetration testing (pen-test for short), and raise awareness about the mess and dire consequences that may be caused by misconfigurations, if they are spotted by an ill-intentionned person.

Most of the time, there are one (or two) go-to ways to go through each mission, but if you find another, good for you! It's a "feature".

###Who made it?



###How do I use it?

Provided you already have an AWS account and the associated CLI keys, read this section.
If you have no idea what I just told you means, don't panic and look at the next section.



In order to start using this software, first run ./config.sh in order to make "profile" and "whitelist" files. Your ip is whitelisted in order to avoid someone else haphazardly getting into your account through a vulnerable app, that'd be ironic.

Then, you may start any mission using start.sh **(file name subject to change)**.

Syntax:
⋅⋅⋅./start.sh <command> argument

Commands: 

At the moment, three are available

⋅⋅⋅ help

This command does not take an argument. It will display a brief helptext to the user, then exit gracefully.

⋅⋅⋅ create

Create is the go-to command to start a mission. It will generate everything you need for a new mission, them prompt the user for confirmation. Should it not be given, the program will delete anything it made.

Legal arguments include:

⋅⋅* mission1

⋅⋅* mission2

⋅⋅* mission3

⋅⋅* mission4

Each will create the associated mission. For more details on missions, consult the "Missions" part in this document, and the ADR.md document.

⋅⋅⋅ destroy

Destroy takes a mission folder as argument (so missionX-id, with or without the trailing slash) and proceeds to ask the user for confirmation before deleting all resources 


###What is an AWS account?

###Will I be charged?

