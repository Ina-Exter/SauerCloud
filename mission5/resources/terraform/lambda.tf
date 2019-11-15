#Lambda file
data "archive_file" "AWS-secgame-mission5-lambda-file-dump-logs" {
    type = "zip"
    source_file = "../code/lambda-dump-logs.py"
    output_path = "../code/lambda-dump-logs.zip"
}

#Lambda assume role permissions
#Log dumping
resource "aws_iam_role" "AWS-secgame-mission5-lambda-logs-dump-role" {
    name = "AWS-secgame-mission5-lambda-logs-dump-service-role-${var.id}"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
             "Action": "sts:AssumeRole",
             "Principal": {
                 "Service": "lambda.amazonaws.com"
             },
             "Effect": "Allow",
             "Sid": ""
    }
  ]
}
EOF
    tags = {
        Name = "AWS-secgame-mission5-lambda-logs-dump-role-${var.id}"
    }
}

#Honeypot suspect group setter
resource "aws_iam_role" "AWS-secgame-mission5-lambda-set-suspect-role" {
    name = "AWS-secgame-mission5-lambda-set-suspect-service-role-${var.id}"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
             "Action": "sts:AssumeRole",
             "Principal": {
                 "Service": "lambda.amazonaws.com"
             },
             "Effect": "Allow",
             "Sid": ""
    }
  ]
}
EOF
    tags = {
        Name = "AWS-secgame-mission5-lambda-set-suspect-role-${var.id}"
    }
}

#Lambda role permissions
#Log dumping
resource "aws_iam_role_policy" "AWS-secgame-mission5-role-lambda-write-logs" {
    name = "AWS-secgame-mission5-role-lambda-write-logs-${var.id}"
    role = "${aws_iam_role.AWS-secgame-mission5-lambda-logs-dump-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF
}

#Honeypot suspect group setter
resource "aws_iam_role_policy" "AWS-secgame-mission5-role-lambda-set-suspect" {
    name = "AWS-secgame-mission5-role-lambda-set-suspect-${var.id}"
    role = "${aws_iam_role.AWS-secgame-mission5-lambda-set-suspect-role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:AddUserToGroup"
      ],
      "Effect": "Allow",
      "Resource": "$(aws_iam_group.AWS-segame-mission5-iam-group-privileged.arn)" 
    },
    {
      "Action": [
        "iam:RemoveUserFromGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:AddUserToGroup"
      ],
      "Effect": "Allow",
      "Resource": "$(aws_iam_group.AWS-segame-mission5-iam-group-suspects.arn)" 
    }
  ]
}
EOF
}

#Lambda
resource "aws_lambda_function" "AWS-secgame-mission5-lambda-dump-logs" {
#filename subject to edition
    filename = "../code/lambda-dump-logs.zip"
    function_name = "AWS-secgame-mission5-lambda-logs-dump-${var.id}"
    role = "${aws_iam_role.AWS-secgame-mission5-lambda-logs-dump-role.arn}"
    handler = "lambda-dump-logs.handler"
    runtime = "python3.7"
    tags = {
        Name = "AWS-secgame-mission5-lambda-logs-dump-${var.id}"
    }
}

#Cloudwatch Rule
resource "aws_cloudwatch_event_rule" "AWS-secgame-mission5-cw-rule-trigger-ec2-termination" {
    name        = "AWS-secgame-mission5-cw-rule-trigger-ec2-termination-${var.id}"

    event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": [
      "terminated",
      "stopped"
    ],
    "instance-id": [
      "${aws_instance.AWS-secgame-mission5-ec2-security-server.id}"
    ]
  }
}
PATTERN
}

#Event target (this assures the tether between lambda and cloudwatch)
resource "aws_cloudwatch_event_target" "AWS-secgame-mission5-event-target-ec2-termination" {
    rule = "${aws_cloudwatch_event_rule.AWS-secgame-mission5-cw-rule-trigger-ec2-termination.name}"
    target_id = "AWS-secgame-mission5-lambda-dump-logs"
    arn = "${aws_lambda_function.AWS-secgame-mission5-lambda-dump-logs.arn}"
}

#Statement (allows execution by cloudwatch event)
resource "aws_lambda_permission" "AWS-secgame-mission5-permission-cloudwatch-lambda-dump-logs" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.AWS-secgame-mission5-lambda-dump-logs.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.AWS-secgame-mission5-cw-rule-trigger-ec2-termination.arn}"
}
