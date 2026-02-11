#!/bin/bash
echo "Stopping application..."
cd /var/www/tailadmin-laravel
docker-compose down || true
echo "Application stopped"
