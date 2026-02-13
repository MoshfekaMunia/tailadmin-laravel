#!/bin/bash
set -ex

echo "======================================"
echo "🚀 Deploying Docker image on EC2"
echo "======================================"

# Variables
REPOSITORY_URI=263751300136.dkr.ecr.us-east-1.amazonaws.com/tailadmin-laravel

# Login to ECR
echo "🔑 Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPOSITORY_URI

# Pull the latest image
echo "📥 Pulling Docker image..."
docker pull $REPOSITORY_URI:$IMAGE_TAG

# Stop old container if exists
echo "🛑 Stopping old container..."
docker stop tailadmin-php-fpm || true
docker rm tailadmin-php-fpm || true

# Start new container
echo "🚀 Starting new container..."
docker run -d --name tailadmin-php-fpm -p 9000:9000 --env-file /var/www/tailadmin-laravel/.env \
$REPOSITORY_URI:$IMAGE_TAG

# Verify
echo "✅ Deployment complete!"
docker ps

