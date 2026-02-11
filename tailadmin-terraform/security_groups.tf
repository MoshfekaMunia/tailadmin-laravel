# Security Group for Application Server
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-App-SG"
  description = "Security group for application server"
  vpc_id      = data.aws_vpc.default.id

  # HTTP
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-App-SG"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Security Group for Database Server
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-DB-SG"
  description = "Security group for database server"
  vpc_id      = data.aws_vpc.default.id

  # MySQL from App SG only
  ingress {
    description     = "MySQL from application server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # SSH from App SG only
  ingress {
    description     = "SSH from application server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-DB-SG"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
