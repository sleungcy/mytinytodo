# Use official PHP-FPM
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and Nginx
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
    nginx \
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
    && mkdir -p /var/run/nginx \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/lib/nginx/body \
    && mkdir -p /var/lib/nginx/fastcgi \
    && mkdir -p /var/lib/nginx/proxy \
    && mkdir -p /var/lib/nginx/scgi \
    && mkdir -p /var/lib/nginx/uwsgi \
    && mkdir -p /tmp/nginx/client_body \
    && mkdir -p /tmp/nginx/proxy \
    && mkdir -p /tmp/nginx/fastcgi \
    && mkdir -p /tmp/nginx/uwsgi \
    && mkdir -p /tmp/nginx/scgi \
    && chmod 755 src/db \
    && chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/run/nginx \
    && chown -R www-data:www-data /var/log/nginx \
    && chown -R www-data:www-data /var/lib/nginx \
    && chown -R www-data:www-data /tmp/nginx \
    && chmod -R 644 /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \;

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/nginx.conf

# Set proper permissions for configuration files
RUN chmod 644 /etc/nginx/nginx.conf

# Configure PHP-FPM
RUN echo "clear_env = no" >> /usr/local/etc/php-fpm.d/www.conf

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Environment variables for PostgreSQL
ENV MTT_DB_TYPE=postgres
ENV MTT_DB_HOST=postgres
ENV MTT_DB_NAME=mytinytodo
ENV MTT_DB_USER=mtt
ENV MTT_DB_PASSWORD=password123
ENV MTT_DB_PREFIX=mtt_
ENV MTT_DB_DRIVER=
ENV MTT_API_USE_PATH_INFO=

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start both PHP-FPM and Nginx
CMD ["/start.sh"]