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
