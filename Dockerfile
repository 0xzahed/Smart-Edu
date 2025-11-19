FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    sqlite3 \
    libsqlite3-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_sqlite pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Set working directory
WORKDIR /var/www/html

# Copy package files first
COPY package*.json ./

# Install Node dependencies
RUN npm install

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev --no-interaction

# Build assets
RUN npm run build

# Create SQLite database directory (will be mounted from Fly volume)
RUN mkdir -p /var/www/html/storage/database
RUN touch /var/www/html/storage/database/database.sqlite

# Set permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/storage
RUN chmod -R 775 /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage/database

# Copy nginx configuration for Fly.io
COPY docker/nginx/fly.conf /etc/nginx/sites-available/default

# Copy supervisor configuration for Fly.io
COPY docker/supervisor/fly-supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port (Fly.io uses 8080)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD curl -f http://localhost:8080/ || exit 1

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
