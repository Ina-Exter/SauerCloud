#IAMR
resource "aws_iam_role" "SauerCloud-mission3-ec2role" {
  name               = "SauerCloud-mission3-ec2role-${var.id}"
  path               = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#IAMP
resource "aws_iam_policy" "SauerCloud-mission3-ec2rolepolicy" {
  name = "SauerCloud-mission3-ec2rolepolicy-${var.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:GenerateCredentialReport",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:Get*",
                "iam:List*",
                "iam:SimulateCustomPolicy",
                "iam:SimulatePrincipalPolicy",
                "iam:CreatePolicyVersion",
                "iam:CreateAccessKey",
                "ec2:RunInstances",
                "ec2:Describe*",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:CreateVolume"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#IAMPR
resource "aws_iam_role_policy_attachment" "SauerCloud-mission3-ec2rolepolicyattachment" {
  role       = aws_iam_role.SauerCloud-mission3-ec2role.name
  policy_arn = aws_iam_policy.SauerCloud-mission3-ec2rolepolicy.arn
}

#IAMIP
resource "aws_iam_instance_profile" "SauerCloud-mission3-ec2listinstanceprofile" {
  name = "SauerCloud-mission3-ec2listinstanceprofile-${var.id}"
  role = aws_iam_role.SauerCloud-mission3-ec2role.name
}

#Users
resource "aws_iam_user" "SauerCloud-mission3-eviladmin" {
  name = "SauerCloud-mission3-eviladmin-${var.id}"
  tags = {
    Name = "SauerCloud-mission3-eviladmin-${var.id}"
  }
}

#Users Policy
resource "aws_iam_policy" "SauerCloud-mission3-eviladminpolicy" {
  name        = "SauerCloud-mission3-eviladminpolicy-${var.id}"
  description = "SauerCloud-mission3-eviladminpolicy-${var.id}"
  policy      = <<POLICY
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

POLICY
}


#Users Policy Attachment
resource "aws_iam_user_policy_attachment" "SauerCloud-mission3-eviladminpolicyattachment" {
  user       = aws_iam_user.SauerCloud-mission3-eviladmin.name
  policy_arn = aws_iam_policy.SauerCloud-mission3-eviladminpolicy.arn
}
