#!/bin/bash

echo "🚀 Starting Insight EDU..."

# Navigate to app directory
cd /var/www/html

# Create database directory and file
echo "📁 Setting up database..."
mkdir -p storage/database
touch storage/database/database.sqlite
chmod 664 storage/database/database.sqlite

# Set permissions
echo "🔐 Setting permissions..."
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Clear caches
echo "🧹 Clearing caches..."
php artisan config:clear 2>/dev/null || true
php artisan cache:clear 2>/dev/null || true
php artisan view:clear 2>/dev/null || true

# Run migrations
echo "🗄️  Running migrations..."
php artisan migrate --force 2>/dev/null || echo "Migrations failed or already run"

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link 2>/dev/null || echo "Storage link already exists"

# Start supervisor
echo "✅ Starting application..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
