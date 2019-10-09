# Architecture Decision Records

## Script

### Why bash?

Short answer: It is fun and I wanted to flex.
Long answer: Python is nice, but bash is less cumbersome (in my modest opinion) and allows for direct integration of the AWS CLI, without having to use a packet and an API.

## Deployment

### Terraform vs CloudFormation

I initially started on CloudFormation, in order to exploit the powerful tool that CloudFormer is. CloudFormer is an AWS-maintained architecture-to-code dumper that swallows your whole account and spits you a nice and even CF script.
I found it easy to use in the beginning. However, CF proved capricious both for the user-data (which I found hard to add), and did not involve IAM roles and some other things.
I did not want to use Terraform in the beginning because I could not and did not want to write the script. However, a nice tool called Terraforming (https://github.com/dtan4/terraforming) allows for a similar infrastructure-to-code dump.
I found it easier to use and modify, and here it went.

Also: I found that CloudFormation is incredibly silent in terminal (I might have missed the --verbose option but eh), where Terraform keeps you up-to-date on what it is doing, even popping reminders every 10 seconds. I find that this is better, 
especially for the user that is curretly deploying potentially costy infrastructure on his account and would rather know not everything is being f***ed-up.

## Missions

### Why this challenge, why that one?

### Big game: The what, the why
