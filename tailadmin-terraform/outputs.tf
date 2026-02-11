output "app_server_public_ip" {
  description = "Application Server Public IP"
  value       = aws_instance.app_server.public_ip
}

output "app_server_private_ip" {
  description = "Application Server Private IP"
  value       = aws_instance.app_server.private_ip
}

output "db_server_private_ip" {
  description = "Database Server Private IP"
  value       = aws_instance.db_server.private_ip
}

output "app_server_id" {
  description = "Application Server Instance ID"
  value       = aws_instance.app_server.id
}

output "db_server_id" {
  description = "Database Server Instance ID"
  value       = aws_instance.db_server.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = data.aws_vpc.default.id
}

output "app_security_group_id" {
  description = "Application Security Group ID"
  value       = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  description = "Database Security Group ID"
  value       = aws_security_group.db_sg.id
}

# SSH commands for different users
output "ssh_command_app_ubuntu" {
  description = "SSH command for Application Server (ubuntu user)"
  value       = "ssh -i ~/.ssh/appserver-key ubuntu@${aws_instance.app_server.public_ip}"
}

output "ssh_command_app_dtuser" {
  description = "SSH command for Application Server (dtuser)"
  value       = "ssh dtuser@${aws_instance.app_server.public_ip}"
}

output "ssh_command_db" {
  description = "SSH command for Database Server"
  value       = "ssh -i ~/.ssh/dbserver-key ubuntu@${aws_instance.db_server.private_ip}"
}

output "app_url" {
  description = "Application URL"
  value       = "http://${aws_instance.app_server.public_ip}"
}

output "key_locations" {
  description = "SSH key file locations"
  value = {
    app_server = "~/.ssh/appserver-key"
    db_server  = "~/.ssh/dbserver-key"
  }
}
