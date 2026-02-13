#!/bin/bash
set -ex
echo "======================================"
echo "🚀 Deploying Docker image on EC2"
echo "======================================"
REPOSITORY_URI=263751300136.dkr.ecr.us-east-1.amazonaws.com/tailadmin-laravel
# IMAGE_TAG should be passed from CodeBuild
if [ -z "$IMAGE_TAG" ]; then
    echo "ERROR: IMAGE_TAG not set!"
    exit 1
fi
echo "📦 Deploying image tag: $IMAGE_TAG"

echo "📂 Updating EC2 host files from Git..."
cd /var/www/tailadmin-laravel
git fetch origin
git reset --hard origin/main  # or origin/master depending on your branch
echo "✅ EC2 host files updated to match repository"

echo "🔑 Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPOSITORY_URI
echo "📥 Pulling Docker image with tag: $IMAGE_TAG..."
docker pull $REPOSITORY_URI:$IMAGE_TAG
echo "🛑 Stopping old container..."
docker stop tailadmin-php-fpm || true
docker rm tailadmin-php-fpm || true
echo "🚀 Starting new container with image: $REPOSITORY_URI:$IMAGE_TAG..."
docker run -d --name tailadmin-php-fpm \
  -p 9000:9000 \
  --env-file /var/www/tailadmin-laravel/.env \
  -v /var/www/tailadmin-laravel/storage:/var/www/html/storage \
  $REPOSITORY_URI:$IMAGE_TAG
echo "✅ Deployment complete!"
docker ps
echo "🔍 Verifying code inside container..."
docker exec tailadmin-php-fpm cat /var/www/html/test.php
echo "🔍 Verifying code on EC2 host..."
cat /var/www/tailadmin-laravel/test.php
echo "📋 Current running image:"
docker inspect tailadmin-php-fpm | grep Image
