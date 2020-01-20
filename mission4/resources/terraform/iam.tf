#User
resource "aws_iam_user" "AWS-secgame-mission4-iam-user-" {
    name = "-${var.id}"
    
    tags = {
		name = "AWS-secgame-mission4-iam-user--${var.id}"
    }
}

#User policy
#TODO ;)

#User policy for entrypoint
resource "aws_iam_user_policy" "AWS-secgame-mission4-iam-user-solus-policy"{
    name = "solus-policy-${var.id}"
    user = "${aws_iam_user.AWS-secgame-mission4-iam-user-solus.id}"
    
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "iam:ListUsers",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
        {
			"Effect": "Allow",
			"Action": "iam:CreateAccessKey",
			"Resource": "${aws_iam_user.AWS-secgame-mission4-iam-user-emetselch.arn}"
        }
    ]
}
EOF
}

#Generate keys
resource "aws_iam_access_key" "AWS-secgame-mission4-iam-user--keys"{
	user = "${aws_iam_user.AWS-secgame-mission4-iam-user-solus.name}"
}
