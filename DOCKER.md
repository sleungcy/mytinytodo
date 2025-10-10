# Docker Setup for myTinyTodo with PostgreSQL

This directory contains Docker configuration files to run myTinyTodo in a containerized environment using Nginx, PHP-FPM, and PostgreSQL for optimal performance, reliability, and data integrity.

## Architecture

This Docker setup uses:
- **Nginx**: Lightweight web server for better performance and lower memory usage
- **PHP-FPM**: PHP FastCGI Process Manager for efficient PHP processing
- **PostgreSQL**: Robust, enterprise-grade relational database
- **Supervisor**: Process manager to run both Nginx and PHP-FPM in a single container

## Quick Start

```bash
# Build and run with PostgreSQL
docker-compose up -d

# Access the application at http://localhost:8080
# PostgreSQL is available at localhost:5432 if you need direct access
```

## Manual Docker Build

```bash
# Build the image
docker build -t mytinytodo .

# Run with external PostgreSQL server
docker run -p 8080:80 \
  -e MTT_DB_HOST=your-postgres-host \
  -e MTT_DB_NAME=mytinytodo \
  -e MTT_DB_USER=your-user \
  -e MTT_DB_PASSWORD=your-password \
  mytinytodo
```

## Environment Variables

The following environment variables can be configured for PostgreSQL:

- `MTT_DB_TYPE`: Always set to `postgres`
- `MTT_DB_HOST`: PostgreSQL host (default: `postgres`)
- `MTT_DB_NAME`: Database name (default: `mytinytodo`)
- `MTT_DB_USER`: Database user (default: `mtt`)
- `MTT_DB_PASSWORD`: Database password (default: `password123`)
- `MTT_DB_PREFIX`: Database table prefix (default: `mtt_`)
- `MTT_DB_DRIVER`: Database driver (optional)
- `MTT_API_USE_PATH_INFO`: Use PATH_INFO for API (optional)

## Data Persistence

PostgreSQL data is automatically persisted in a Docker volume named `postgres_data`. This ensures your todo data survives container restarts and updates.

## PostgreSQL Database Access

If you need direct access to the PostgreSQL database:

```bash
# Connect to PostgreSQL from host machine
docker-compose exec postgres psql -U mtt -d mytinytodo

# Or using a PostgreSQL client
psql -h localhost -p 5432 -U mtt -d mytinytodo

# View database logs
docker-compose logs postgres

# Backup database
docker-compose exec postgres pg_dump -U mtt mytinytodo > backup.sql

# Restore database
docker-compose exec -T postgres psql -U mtt -d mytinytodo < backup.sql
```

## First Run Setup

1. Start the services: `docker-compose up -d`
2. Wait for PostgreSQL to be ready (check with `docker-compose logs postgres`)
3. Access the application in your browser at http://localhost:8080
4. Follow the setup wizard to initialize the PostgreSQL database
5. Create your first todo list

## Stopping the Application

```bash
# Stop and remove containers
docker-compose down

# Stop and remove containers with volumes (WARNING: This will delete your data)
docker-compose down -v
```

## Customization

### Custom PostgreSQL Configuration
You can mount a custom PostgreSQL configuration:
```bash
# Create custom postgresql.conf
# Then mount it:
docker run -v $(pwd)/postgresql.conf:/etc/postgresql/postgresql.conf postgres:15

# Or extend the docker-compose.yml
```

### Custom Application Configuration
You can mount a custom `config.php` file:
```bash
docker run -v $(pwd)/my-config.php:/var/www/html/src/config.php mytinytodo
```

### Custom Themes
Mount custom themes to the theme directory:
```bash
docker run -v $(pwd)/my-theme:/var/www/html/src/content/theme/my-theme mytinytodo
```

## Troubleshooting

### Check Container Logs
```bash
docker-compose logs mytinytodo
```

### Access Container Shell
```bash
docker-compose exec mytinytodo bash
```

### Health Check
The container includes a health check that verifies the web server is responding:
```bash
docker ps  # Check if container shows as "healthy"
```

## Production Considerations

1. **Security**: 
   - Change default PostgreSQL passwords in production
   - Use environment files (.env) for sensitive data
   - Consider using PostgreSQL with SSL/TLS
2. **SSL/TLS**: Use a reverse proxy (nginx, traefik) to handle SSL termination
3. **Backups**: 
   - Set up automated PostgreSQL backups using pg_dump
   - Store backups in external storage (S3, etc.)
4. **Monitoring**: Monitor PostgreSQL performance and connection pools
5. **Updates**: 
   - Monitor for application and PostgreSQL updates
   - Test updates in staging environment first
6. **Resources**: Tune PostgreSQL settings based on your server resources