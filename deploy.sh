#!/bin/bash
set -ex
echo "======================================"
echo "🚀 Deploying Docker image on EC2"
echo "======================================"

REPOSITORY_URI=263751300136.dkr.ecr.us-east-1.amazonaws.com/tailadmin-laravel

echo "🔑 Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPOSITORY_URI

echo "📥 Pulling Docker image..."
docker pull $REPOSITORY_URI:$IMAGE_TAG

echo "🛑 Stopping old container..."
docker stop tailadmin-php-fpm || true
docker rm tailadmin-php-fpm || true

echo "🚀 Starting new container..."
docker run -d --name tailadmin-php-fpm \
  -p 9000:9000 \
  --env-file /var/www/tailadmin-laravel/.env \
  -v /var/www/tailadmin-laravel/storage:/var/www/html/storage \
  $REPOSITORY_URI:$IMAGE_TAG

echo "✅ Deployment complete!"
docker ps

echo "🔍 Verifying code inside container..."
docker exec tailadmin-php-fpm cat /var/www/html/test.php
