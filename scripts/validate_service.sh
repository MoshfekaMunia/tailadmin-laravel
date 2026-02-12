#!/bin/bash
echo "Validating..."
sleep 5
if ! docker ps | grep -q tailadmin-php-fpm; then
    echo "ERROR: Container not running"
    exit 1
fi
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$HTTP_CODE" != "200" ]; then
    echo "ERROR: HTTP $HTTP_CODE"
    exit 1
fi
echo "Validation successful"
