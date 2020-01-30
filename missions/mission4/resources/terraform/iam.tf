#User
resource "aws_iam_user" "SauerCloud-mission4-iam-user-juan" {
  name = "juan-${var.id}"

  tags = {
    name = "SauerCloud-mission4-iam-user-juan-${var.id}"
  }
}

#User policy
resource "aws_iam_policy" "SauerCloud-mission4-juan-userpolicy" {
  name   = "SauerCloud-mission4-juan-userpolicy-${var.id}"
  policy = <<-POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [  
                "ec2:RunInstances",
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

#Policy attachment
resource "aws_iam_policy_attachment" "SauerCloud-mission5-policyattachment-user-juan" {
  name       = "SauerCloud-mission5-policyattachment-user-juan-${var.id}"
  users      = [aws_iam_user.SauerCloud-mission4-iam-user-juan.name]
  roles      = []
  groups     = []
  policy_arn = aws_iam_policy.SauerCloud-mission4-juan-userpolicy.arn
}

#Generate keys
resource "aws_iam_access_key" "SauerCloud-mission4-iam-user-juan-keys" {
  user = aws_iam_user.SauerCloud-mission4-iam-user-juan.name
}
