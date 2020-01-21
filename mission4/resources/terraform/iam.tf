#User
resource "aws_iam_user" "AWS-secgame-mission4-iam-user-" {
    name = "AWS-secgame-mission4-iam-user-${var.id}"
    
    tags = {
		name = "AWS-secgame-mission4-iam-user--${var.id}"
    }
}

#User policy
resource "aws_iam_policy" "AWS-secgame-mission4-userpolicy" {
  name = "AWS-secgame-mission4-userpolicy-${var.id}"
  description = "AWS-secgame-mission4-userpolicy-${var.id}"
  policy = <<-POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [  
                "ec2:StartInstances",
                "ec2:Describe*",
                "ec2:CreateKeyPair",
                "ec2:DeleteKeyPair"
                ],
            "Resource": "*"
        }
        ]
    }
    POLICY
}



#Generate keys
resource "aws_iam_access_key" "AWS-secgame-mission4-iam-user--keys"{
	user = "aws_iam_user.AWS-secgame-mission4-iam-user-.name"
}
