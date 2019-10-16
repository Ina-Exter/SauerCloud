output "ec2_ip_addr" {
  value = aws_instance.AWS-secgame-mission3-ec2-completely-safe-critical-server.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.AWS-secgame-mission3-ec2-completely-safe-critical-server.id
}
