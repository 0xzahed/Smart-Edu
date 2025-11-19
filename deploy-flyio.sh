#!/bin/bash

echo "🚀 Fly.io Deployment Script for Insight EDU"
echo "==========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if flyctl is installed
if ! command -v fly &> /dev/null; then
    echo -e "${YELLOW}⚠️  Fly CLI not found. Installing...${NC}"
    curl -L https://fly.io/install.sh | sh
    
    # Add to PATH
    export FLYCTL_INSTALL="$HOME/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"
    
    echo -e "${GREEN}✅ Fly CLI installed!${NC}"
    echo ""
    echo "Please run this script again or add to your ~/.zshrc:"
    echo 'export FLYCTL_INSTALL="$HOME/.fly"'
    echo 'export PATH="$FLYCTL_INSTALL/bin:$PATH"'
    exit 0
fi

echo -e "${GREEN}✅ Fly CLI found${NC}"
echo ""

# Check if logged in
if ! fly auth whoami &> /dev/null; then
    echo -e "${BLUE}🔐 Please login to Fly.io...${NC}"
    fly auth login
fi

echo ""
echo -e "${BLUE}Select an option:${NC}"
echo ""
echo "1) 🚀 First Time Deploy (Complete Setup)"
echo "2) 📦 Deploy Updates"
echo "3) 🔑 Set Environment Variables"
echo "4) 📊 View Logs"
echo "5) 🖥️  SSH into App"
echo "6) 🗄️  Run Migrations"
echo "7) 🧹 Clear Cache"
echo "8) 📈 View Status"
echo "9) 🌐 Open App in Browser"
echo "10) 🔄 Restart App"
echo "11) ❌ Exit"
echo ""
read -p "Enter your choice (1-11): " choice

case $choice in
    1)
        echo -e "${BLUE}🚀 Starting first-time deployment...${NC}"
        echo ""
        
        # Launch app
        echo "Step 1: Creating Fly.io app..."
        fly launch --no-deploy
        
        echo ""
        echo "Step 2: Creating persistent volume for database..."
        read -p "Enter your app region (e.g., sin, lhr, iad): " region
        fly volumes create insight_edu_data --region "$region" --size 3
        
        echo ""
        echo "Step 3: Generating APP_KEY..."
        APP_KEY=$(php artisan key:generate --show)
        fly secrets set APP_KEY="$APP_KEY"
        
        echo ""
        echo "Step 4: Deploying application..."
        fly deploy
        
        echo ""
        echo -e "${GREEN}✅ Deployment complete!${NC}"
        echo ""
        echo "🌐 Opening your app..."
        fly open
        ;;
        
    2)
        echo -e "${BLUE}📦 Deploying updates...${NC}"
        fly deploy
        echo -e "${GREEN}✅ Deployment complete!${NC}"
        ;;
        
    3)
        echo -e "${BLUE}🔑 Setting environment variables...${NC}"
        echo ""
        echo "Enter your secrets (leave blank to skip):"
        echo ""
        
        read -p "MAIL_USERNAME: " mail_user
        if [ ! -z "$mail_user" ]; then
            fly secrets set MAIL_USERNAME="$mail_user"
        fi
        
        read -p "MAIL_PASSWORD (Gmail App Password): " mail_pass
        if [ ! -z "$mail_pass" ]; then
            fly secrets set MAIL_PASSWORD="$mail_pass"
        fi
        
        read -p "GOOGLE_DRIVE_CLIENT_ID: " gd_client
        if [ ! -z "$gd_client" ]; then
            fly secrets set GOOGLE_DRIVE_CLIENT_ID="$gd_client"
        fi
        
        read -p "GOOGLE_DRIVE_CLIENT_SECRET: " gd_secret
        if [ ! -z "$gd_secret" ]; then
            fly secrets set GOOGLE_DRIVE_CLIENT_SECRET="$gd_secret"
        fi
        
        read -p "GOOGLE_DRIVE_REFRESH_TOKEN: " gd_token
        if [ ! -z "$gd_token" ]; then
            fly secrets set GOOGLE_DRIVE_REFRESH_TOKEN="$gd_token"
        fi
        
        read -p "GOOGLE_DRIVE_FOLDER_ID: " gd_folder
        if [ ! -z "$gd_folder" ]; then
            fly secrets set GOOGLE_DRIVE_FOLDER_ID="$gd_folder"
        fi
        
        echo -e "${GREEN}✅ Secrets updated!${NC}"
        ;;
        
    4)
        echo -e "${BLUE}📊 Viewing logs...${NC}"
        fly logs
        ;;
        
    5)
        echo -e "${BLUE}🖥️  Connecting to SSH...${NC}"
        fly ssh console
        ;;
        
    6)
        echo -e "${BLUE}🗄️  Running migrations...${NC}"
        fly ssh console -C "php /var/www/html/artisan migrate --force"
        echo -e "${GREEN}✅ Migrations complete!${NC}"
        ;;
        
    7)
        echo -e "${BLUE}🧹 Clearing cache...${NC}"
        fly ssh console -C "php /var/www/html/artisan cache:clear"
        fly ssh console -C "php /var/www/html/artisan config:clear"
        fly ssh console -C "php /var/www/html/artisan view:clear"
        echo -e "${GREEN}✅ Cache cleared!${NC}"
        ;;
        
    8)
        echo -e "${BLUE}📈 App Status:${NC}"
        echo ""
        fly status
        echo ""
        fly info
        ;;
        
    9)
        echo -e "${BLUE}🌐 Opening app in browser...${NC}"
        fly open
        ;;
        
    10)
        echo -e "${BLUE}🔄 Restarting app...${NC}"
        fly apps restart
        echo -e "${GREEN}✅ App restarted!${NC}"
        ;;
        
    11)
        echo -e "${GREEN}👋 Goodbye!${NC}"
        exit 0
        ;;
        
    *)
        echo -e "${YELLOW}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✨ Done!${NC}"
