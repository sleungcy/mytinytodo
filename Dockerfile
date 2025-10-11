# Use official PHP-FPM
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies (removing nginx)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    libzip-dev \
    libpq-dev \
    unzip \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions (PostgreSQL focused)
RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    mbstring \
    intl \
    zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer files first for better layer caching
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy application files
COPY . .

# Set up configuration for Docker
RUN cp src/docker-config.php src/config.php

# Create necessary directories and set permissions
RUN mkdir -p src/db \
    && chmod 755 src/db \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 644 /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \;

# Configure PHP-FPM
RUN echo "clear_env = no" >> /usr/local/etc/php-fpm.d/www.conf

# Environment variables for PostgreSQL
ENV MTT_DB_TYPE=postgres
ENV MTT_DB_HOST=postgres
ENV MTT_DB_NAME=mytinytodo
ENV MTT_DB_USER=mtt
ENV MTT_DB_PASSWORD=password123
ENV MTT_DB_PREFIX=mtt_
ENV MTT_DB_DRIVER=
ENV MTT_API_USE_PATH_INFO=

# Expose PHP-FPM port
EXPOSE 9000

# Health check (checking PHP-FPM process)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD php-fpm -t || exit 1

# Start PHP-FPM
CMD ["php-fpm", "-F"]