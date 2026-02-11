variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "TailAdmin"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "Database EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Just the key names, not the actual keys
variable "app_key_name" {
  description = "SSH key pair name for app server"
  type        = string
  default     = "appserver-key"
}

variable "db_key_name" {
  description = "SSH key pair name for DB server"
  type        = string
  default     = "dbserver-key"
}
