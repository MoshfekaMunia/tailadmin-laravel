#!/bin/bash
echo "Starting application..."
cd /var/www/tailadmin-laravel

export AWS_REGION="us-east-1"
export AWS_ACCOUNT_ID="263751300136"

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

sed -i "s|\${AWS_ACCOUNT_ID}|${AWS_ACCOUNT_ID}|g" docker-compose.yml
sed -i "s|\${AWS_REGION}|${AWS_REGION}|g" docker-compose.yml

docker-compose pull
docker-compose up -d

sleep 10
docker-compose exec -T php-fpm php artisan migrate --force || true
docker-compose exec -T php-fpm php artisan config:cache || true
docker-compose exec -T php-fpm php artisan route:cache || true

echo "Application started"
