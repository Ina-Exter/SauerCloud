#Users

#Admin user
resource "aws_iam_user" "AWS-secgame-mission5-iam-admin-hades" {
    name = "hades-${var.id}"
    
    tags = {
		name = "AWS-secgame-mission5-iam-admin-hades-${var.id}"
    }
}

#User2 (honeypot segment)
resource "aws_iam_user" "AWS-secgame-mission5-iam-user-emetselch" {
    name = "emetselch-${var.id}"
    
    tags = {
		name = "AWS-secgame-mission5-iam-user-emetselch-${var.id}"
    }
}

#User1 (entrypoint segment)
resource "aws_iam_user" "AWS-secgame-mission5-iam-user-solus" {
    name = "solus-${var.id}"
    
    tags = {
		name = "AWS-secgame-mission5-iam-user-solus-${var.id}"
    }
}

#Admin policy tethered to admin 
#Hades should be the only one to access the target bucket
resource "aws_iam_user_policy" "AWS-secgame-mission5-iam-admin-hades-policy"{
    name = "hades-policy-${var.id}"
    user = "${aws_iam_user.AWS-secgame-mission5-iam-admin-hades.id}"
    
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

#User policy for entrypoint
resource "aws_iam_user_policy" "AWS-secgame-mission5-iam-user-solus-policy"{
    name = "solus-policy-${var.id}"
    user = "${aws_iam_user.AWS-secgame-mission5-iam-user-solus.id}"
    
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
			"Resource": "${aws_iam_user.AWS-secgame-mission5-iam-user-emetselch.arn}"
        }
    ]
}
EOF
}

#Generate keys
resource "aws_iam_access_key" "AWS-secgame-mission5-iam-admin-hades-keys"{
	user = "${aws_iam_user.AWS-secgame-mission5-iam-admin-hades.name}"
}

resource "aws_iam_access_key" "AWS-secgame-mission5-iam-user-emetselch-keys"{
	user = "${aws_iam_user.AWS-secgame-mission5-iam-user-emetselch.name}"
}

resource "aws_iam_access_key" "AWS-secgame-mission5-iam-user-solus-keys"{
	user = "${aws_iam_user.AWS-secgame-mission5-iam-user-solus.name}"
}

#Groups
resource "aws_iam_group" "AWS-secgame-mission5-iam-group-suspects"{
    name = "suspects-${var.id}" #group you get if you FUBAR the mission
}

resource "aws_iam_group" "AWS-secgame-mission5-iam-group-privileged"{
    name = "privileged-${var.id}" #group you aim for to shutdown security server
}

resource "aws_iam_group" "AWS-secgame-mission5-iam-group-standard"{
	name = "standard-${var.id}" #group for emetselch
}

#Group membership
resource "aws_iam_group_membership" "AWS-secgame-mission5-gm-standard" {
    name = "AWS-secgame-mission5-gm-standard-${var.id}"

    users = [
        "${aws_iam_user.AWS-secgame-mission5-iam-user-emetselch.name}",
    ]

    group = "${aws_iam_group.AWS-secgame-mission5-iam-group-standard.name}"
}

#Group policies
resource "aws_iam_group_policy" "AWS-secgame-mission5-iam-group-policy-suspects" {
  name = "AWS-secgame-mission5-iam-group-policy-suspects-${var.id}"
  group = "${aws_iam_group.AWS-secgame-mission5-iam-group-suspects.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "iam:ListGroups",
        "iam:ListGroupsForUser",
        "iam:ListUsers",
        "lambda:ListFunctions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:StopInstances"
      ],
      "Effect": "Allow",
      "Resource": "${aws_instance.AWS-secgame-mission5-ec2-hyper-critical-security-hypervisor.arn}" 
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:GetFunction"
       ],
       "Resource": "${aws_lambda_function.AWS-secgame-mission5-lambda-change-group.arn}"
    }
  ]
}
EOF
} 

resource "aws_iam_group_policy" "AWS-secgame-mission5-iam-group-policy-privileged" {
  name  = "AWS-secgame-mission5-iam-group-policy-privileged-${var.id}"
  group = "${aws_iam_group.AWS-secgame-mission5-iam-group-privileged.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "logs:*",
        "iam:ListUsers",
        "iam:listGroups",
        "iam:ListGroupsForUser",
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:StopInstances"
      ],
      "Effect": "Allow",
      "Resource": "${aws_instance.AWS-secgame-mission5-ec2-dynamo-handler.arn}" 
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:GetLayerVersion",
        "lambda:GetFunction",
        "lambda:ListLayerVersions",
        "lambda:ListLayers",
        "lambda:GetFunctionConfiguration",
        "lambda:GetLayerVersionPolicy",
        "lambda:GetPolicy"
       ],
       "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2-instance-connect:SendSSHPublicKey"
      ],
      "Resource": [
        "${aws_instance.AWS-secgame-mission5-ec2-dynamo-handler.arn}",
        "${aws_instance.AWS-secgame-mission5-ec2-mail-server.arn}"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:osuser": "ec2-user"
        }
      }
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket"
        ],
        "Resource": "${aws_s3_bucket.AWS-secgame-mission5-s3-es.arn}"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject"
        ],
        "Resource": "${aws_s3_bucket.AWS-secgame-mission5-s3-es.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "AWS-secgame-mission5-iam-group-policy-standard" {
  name  = "AWS-secgame-mission5-iam-group-policy-standard-${var.id}"
  group = "${aws_iam_group.AWS-secgame-mission5-iam-group-standard.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "iam:ListUsers",
        "iam:ListGroups",
        "iam:ListGroupsForUser",
        "lambda:ListFunctions",
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Effect": "Allow",
      "Resource": "${aws_instance.AWS-secgame-mission5-ec2-hyper-critical-security-hypervisor.arn}" 
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:GetLayerVersion",
        "lambda:GetFunction",
        "lambda:ListLayerVersions",
        "lambda:ListLayers",
        "lambda:GetFunctionConfiguration",
        "lambda:GetLayerVersionPolicy",
        "lambda:GetPolicy"
       ],
       "Resource": "${aws_lambda_function.AWS-secgame-mission5-lambda-change-group.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2-instance-connect:SendSSHPublicKey"
      ],
      "Resource": [
        "${aws_instance.AWS-secgame-mission5-ec2-mail-server.arn}"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:osuser": "ec2-user"
        }
      }
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket"
        ],
        "Resource": "${aws_s3_bucket.AWS-secgame-mission5-s3-es.arn}"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject"
        ],
        "Resource": "${aws_s3_bucket.AWS-secgame-mission5-s3-es.arn}/*"
    }
  ]
}
EOF
}
