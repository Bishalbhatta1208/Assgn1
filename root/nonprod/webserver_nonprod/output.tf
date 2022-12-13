# Step 1 - Public IP Address of Bastion
output "public_ip" {
  value = aws_instance.Bastionhost.public_ip
}


output "private_ip" {
  value = aws_instance.webserver[*].private_ip
}

/*
output "private_ip2" {
  value = aws_instance.Web_Server02.private_ip
}
*/

