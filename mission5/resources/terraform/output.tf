output "bastion_ip_addr" {
  value = aws_instance.AWS-secgame-mission5-ec2-Evil-bastion-for-evil-access.public_ip
}