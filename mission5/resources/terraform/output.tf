output "ec2_instance_id" {
    value = "${aws_instance.AWS-secgame-mission5-ec2-security-server.id}"
}

output "emetselch_key" {
	value = "${aws_iam_access_key.AWS-secgame-mission5-iam-user-emetselch-keys.id}"
}

output "emetselch_secret_key" {
	value = "${aws_iam_access_key.AWS-secgame-mission5-iam-user-emetselch-keys.secret}"
}
