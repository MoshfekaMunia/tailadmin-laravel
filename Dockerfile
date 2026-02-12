FROM php:8.2-fpm

WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring zip dom xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Copy composer files
COPY composer.json composer.lock* ./

# Install dependencies (ignore platform requirements since we're in Docker)
RUN composer install \
    --no-dev \
    --no-scripts \
    --no-autoloader \
    --prefer-dist \
    --no-interaction \
    --ignore-platform-reqs

# Copy application
COPY . .

# Generate optimized autoloader
RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
