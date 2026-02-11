#!/bin/bash
set -e

# Log everything
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting application server setup..."

# Update system
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install Docker
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Git
apt-get install -y git

# Install AWS CLI
apt-get install -y awscli

# Install CodeDeploy Agent
apt-get install -y ruby-full wget
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto
service codedeploy-agent start
systemctl enable codedeploy-agent

# Create application directory
mkdir -p /home/ubuntu/tailadmin-laravel
chown -R ubuntu:ubuntu /home/ubuntu/tailadmin-laravel

# Add dtuser with the provided SSH key
echo "Creating dtuser..."
useradd -m -s /bin/bash dtuser

# Set up SSH for dtuser
mkdir -p /home/dtuser/.ssh
chmod 700 /home/dtuser/.ssh

# Add the provided public key
echo "${dt_ssh_public_key}" > /home/dtuser/.ssh/authorized_keys
chmod 600 /home/dtuser/.ssh/authorized_keys
chown -R dtuser:dtuser /home/dtuser/.ssh

# Add dtuser to docker and sudo groups
usermod -aG docker dtuser
usermod -aG sudo dtuser

# Allow dtuser to use sudo without password (optional, for convenience)
echo "dtuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dtuser
chmod 440 /etc/sudoers.d/dtuser

# Save DB private IP to a file for later use
echo "${db_private_ip}" > /home/ubuntu/db_private_ip.txt
chown ubuntu:ubuntu /home/ubuntu/db_private_ip.txt

echo "Application server setup complete!" 
date >> /var/log/user-data-complete.log
