# Application Server
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_key.key_name
  subnet_id              = data.aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }

  user_data = templatefile("${path.module}/user-data-app.sh", {
    db_private_ip     = aws_instance.db_server.private_ip
    dt_ssh_public_key = local.dt_ssh_public_key
  })

  tags = {
    Name        = "Application-Server"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Role        = "Application"
  }

  depends_on = [aws_instance.db_server]
}

# Database Server
resource "aws_instance" "db_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.db_instance_type
  key_name               = aws_key_pair.db_key.key_name
  subnet_id              = data.aws_subnet.db_subnet.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }

  user_data = file("${path.module}/user-data-db.sh")

  tags = {
    Name        = "DB-Server"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Role        = "Database"
  }
}
