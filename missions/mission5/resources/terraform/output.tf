output "ec2_ddb_instance_id" {
  value = aws_instance.SauerCloud-mission5-ec2-dynamo-handler.id
}

output "ec2_mailserver_instance_id" {
  value = aws_instance.SauerCloud-mission5-ec2-mail-server.id
}

output "ec2_mailserver_public_ip" {
  value = aws_instance.SauerCloud-mission5-ec2-mail-server.public_ip
}

output "emmyselly_key" {
  value = aws_iam_access_key.SauerCloud-mission5-iam-user-emmyselly-keys.id
}

output "emmyselly_secret_key" {
  value = aws_iam_access_key.SauerCloud-mission5-iam-user-emmyselly-keys.secret
}

output "solus_key" {
  value = aws_iam_access_key.SauerCloud-mission5-iam-user-solus-keys.id
}

output "solus_secret_key" {
  value = aws_iam_access_key.SauerCloud-mission5-iam-user-solus-keys.secret
}
