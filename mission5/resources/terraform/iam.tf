#Users

#Admin user
resource "aws_iam_user" "AWS-secgame-mission5-iam-admin-hades" {
    name = "hades-${var.id}"
    
    tags = {
		name = "AWS-secgame-mission5-iam-admin-hades-${var.id}"
    }
}

#Admin policy tethered to admin user
#Hades should be the only one to access the bucket
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

#Generate keys
resource "aws_iam_access_key" "AWS-secgame-mission5-iam-admin-hades-keys"{
	user = "${aws_iam_user.AWS-secgame-mission5-iam-admin-hades.name}"
}

#Groups
resource "aws_iam_group" "AWS-secgame-mission5-iam-group-suspects"{
    name = "suspects-${var.id}"
}

resource "aws_iam_group" "AWS-secgame-mission5-iam-group-privileged"{
    name = "privileged-${var.id}"
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
        "*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
} #This policy is a bit restrictive, might want to change it later so as not to force a restart if needed

resource "aws_iam_group_policy" "AWS-secgame-mission5-iam-group-policy-privileged" {
  name  = "AWS-secgame-mission5-iam-group-policy-privileged-${var.id}"
  group = "${aws_iam_group.AWS-secgame-mission5-iam-group-privileged.id}"

#LAMBDA:* IS PLACEHOLDER. RESTRICT

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "lambda:*" 
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
