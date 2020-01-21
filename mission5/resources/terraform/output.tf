output "ec2_ddb_instance_id" {
    value = "${aws_instance.AWS-secgame-mission5-ec2-dynamo-handler.id}"
}

output "ec2_mailserver_instance_id" {
    value = aws_instance.AWS-secgame-mission5-ec2-mail-server.id
}

output "ec2_mailserver_public_ip" {
    value = aws_instance.AWS-secgame-mission5-ec2-mail-server.public_ip
}

output "emetselch_key" {
	value = aws_iam_access_key.AWS-secgame-mission5-iam-user-emetselch-keys.id
}

output "emetselch_secret_key" {
	value = aws_iam_access_key.AWS-secgame-mission5-iam-user-emetselch-keys.secret
}

output "solus_key" {
	value = aws_iam_access_key.AWS-secgame-mission5-iam-user-solus-keys.id
}

output "solus_secret_key" {
	value = aws_iam_access_key.AWS-secgame-mission5-iam-user-solus-keys.secret
}
