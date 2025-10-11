#!/bin/bash
set -e

# Start PHP-FPM in background
php-fpm --daemonize

# Start Nginx in foreground (keeps container running)
exec nginx -g 'daemon off;'