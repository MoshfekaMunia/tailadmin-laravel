#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install MySQL
apt-get install -y mysql-server

# Start and enable MySQL
systemctl start mysql
systemctl enable mysql

# Configure MySQL to listen on all interfaces
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

# Set root password and create database
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'SecureRootPass123!';"
mysql -u root -pSecureRootPass123! -e "CREATE DATABASE IF NOT EXISTS tailadmin_db;"
mysql -u root -pSecureRootPass123! -e "CREATE USER IF NOT EXISTS 'tailadmin_user'@'%' IDENTIFIED BY 'TailAdminPass123!';"
mysql -u root -pSecureRootPass123! -e "GRANT ALL PRIVILEGES ON tailadmin_db.* TO 'tailadmin_user'@'%';"
mysql -u root -pSecureRootPass123! -e "FLUSH PRIVILEGES;"

# Install AWS CLI for backups
apt-get install -y awscli

# Create backup directory
mkdir -p /backups/mysql
chown ubuntu:ubuntu /backups/mysql

echo "Database server setup complete!" > /var/log/user-data.log
