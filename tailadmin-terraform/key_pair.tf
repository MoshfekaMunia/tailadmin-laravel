# Create AWS Key Pair for App Server
resource "aws_key_pair" "app_key" {
  key_name   = var.app_key_name
  public_key = local.app_ssh_public_key

  tags = {
    Name        = "${var.project_name}-App-KeyPair"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Create AWS Key Pair for DB Server
resource "aws_key_pair" "db_key" {
  key_name   = var.db_key_name
  public_key = local.db_ssh_public_key

  tags = {
    Name        = "${var.project_name}-DB-KeyPair"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
