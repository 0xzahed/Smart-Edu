# 🚀 Fly.io Deployment Guide - Insight EDU

## ✅ Prerequisites
- GitHub account (already done ✓)
- Code pushed to: `https://github.com/arnubxx/Insight_EDU.git` ✓

## 📋 Deployment Steps

### **Step 1: Install Fly.io CLI**

**macOS:**
```bash
curl -L https://fly.io/install.sh | sh
```

**After installation, add to PATH:**
```bash
echo 'export FLYCTL_INSTALL="$HOME/.fly"' >> ~/.zshrc
echo 'export PATH="$FLYCTL_INSTALL/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Verify installation:**
```bash
flyctl version
```

---

### **Step 2: Sign Up & Login**

```bash
# Sign up or login (opens browser)
fly auth signup

# Or if you have an account
fly auth login
```

---

### **Step 3: Launch Your App**

```bash
# Navigate to your project
cd /Users/arnubdatta/Desktop/php/Smart-Edu

# Launch (fly.toml already created)
fly launch --no-deploy

# When prompted:
# - App name: insight-edu (or press Enter for generated name)
# - Region: Choose closest (sin for Singapore, lhr for London, etc.)
# - Setup PostgreSQL? → NO (we're using SQLite)
# - Setup Redis? → NO
# - Deploy now? → NO
```

This creates your app on Fly.io without deploying yet.

---

### **Step 4: Create Persistent Volume for SQLite**

```bash
# Create a 3GB volume for your database
fly volumes create insight_edu_data --region sin --size 3

# Verify volume created
fly volumes list
```

**Important:** The region must match your app's region!

---

### **Step 5: Set Environment Variables**

```bash
# Generate and set APP_KEY
fly secrets set APP_KEY=$(php artisan key:generate --show)

# Set other secrets (optional)
fly secrets set MAIL_USERNAME=your-email@gmail.com
fly secrets set MAIL_PASSWORD=your-gmail-app-password
fly secrets set GOOGLE_DRIVE_CLIENT_ID=your_client_id
fly secrets set GOOGLE_DRIVE_CLIENT_SECRET=your_client_secret
fly secrets set GOOGLE_DRIVE_REFRESH_TOKEN=your_refresh_token
fly secrets set GOOGLE_DRIVE_FOLDER_ID=your_folder_id
```

---

### **Step 6: Deploy!**

```bash
# Deploy your application
fly deploy

# This will:
# - Build Docker image
# - Push to Fly.io
# - Run migrations (from release_command in fly.toml)
# - Start your app
```

**First deployment takes 3-5 minutes.**

---

### **Step 7: Open Your App**

```bash
# Open in browser
fly open

# Your app is now live at:
# https://insight-edu.fly.dev
```

---

## 🎯 Post-Deployment Commands

### **View Logs:**
```bash
# Live logs
fly logs

# Follow logs (real-time)
fly logs -a insight-edu
```

### **Run Artisan Commands:**
```bash
# Run migrations
fly ssh console -C "php /var/www/html/artisan migrate --force"

# Clear cache
fly ssh console -C "php /var/www/html/artisan cache:clear"

# Create storage link
fly ssh console -C "php /var/www/html/artisan storage:link"

# Seed database
fly ssh console -C "php /var/www/html/artisan db:seed --force"
```

### **SSH into Container:**
```bash
fly ssh console

# Inside container:
cd /var/www/html
php artisan tinker
```

### **Scale Your App:**
```bash
# Check current scale
fly scale show

# Scale memory (if needed)
fly scale memory 1024

# Scale CPU
fly scale vm shared-cpu-2x
```

### **Check App Status:**
```bash
fly status
fly info
```

---

## 🔄 Update Your App

```bash
# Make changes, commit, and push
git add .
git commit -m "Your changes"
git push insight main

# Then deploy
fly deploy
```

**Automatic deployments:**
- Set up GitHub Actions (optional)
- Every push auto-deploys

---

## 📊 Monitor Resources

### **Dashboard:**
Visit: https://fly.io/dashboard

### **Check Metrics:**
```bash
fly dashboard metrics
```

### **View Volumes:**
```bash
fly volumes list
```

---

## 🔧 Troubleshooting

### **App Won't Start:**
```bash
# Check logs
fly logs

# Check app status
fly status

# Restart app
fly apps restart insight-edu
```

### **Database Errors:**
```bash
# SSH into container
fly ssh console

# Check database file
ls -la /var/www/html/storage/database/

# Run migrations manually
cd /var/www/html
php artisan migrate:fresh --force
```

### **Permission Issues:**
```bash
fly ssh console -C "chmod -R 775 /var/www/html/storage"
```

### **View Environment Variables:**
```bash
fly secrets list
```

---

## 💰 Fly.io Free Tier

**What You Get:**
- ✅ Up to 3 shared-cpu VMs (256MB RAM each)
- ✅ 3GB persistent volumes (1 per region)
- ✅ 160GB bandwidth/month
- ✅ Enough for small to medium projects

**Your Setup:**
- 1 VM (512MB RAM) - within free tier ✓
- 3GB volume for database ✓

**Cost:** **$0/month** (within free tier)

---

## 🌍 Custom Domain (Optional)

```bash
# Add custom domain
fly certs add yourdomain.com

# Follow DNS instructions
# Update APP_URL in secrets:
fly secrets set APP_URL=https://yourdomain.com
```

---

## ⚙️ Advanced Configuration

### **Auto-scaling:**
Already configured in `fly.toml`:
- `auto_stop_machines = true` - Stops when idle
- `auto_start_machines = true` - Starts on request
- `min_machines_running = 0` - Saves resources

### **Health Checks:**
Configured in Dockerfile - Fly.io monitors your app automatically

### **Regions:**
```bash
# List available regions
fly platform regions

# Add another region
fly regions add lhr  # London

# List current regions
fly regions list
```

---

## 📱 Quick Reference

| Command | Description |
|---------|-------------|
| `fly deploy` | Deploy app |
| `fly open` | Open app in browser |
| `fly logs` | View logs |
| `fly status` | Check status |
| `fly ssh console` | SSH into app |
| `fly secrets list` | List secrets |
| `fly volumes list` | List volumes |
| `fly apps restart` | Restart app |
| `fly dashboard` | Open dashboard |

---

## 🆘 Need Help?

- **Fly.io Docs:** https://fly.io/docs
- **Community:** https://community.fly.io
- **Status:** https://status.flyio.net

---

## ✨ Your App URLs

- **App:** https://insight-edu.fly.dev
- **Dashboard:** https://fly.io/apps/insight-edu
- **Metrics:** https://fly.io/apps/insight-edu/metrics

---

**Ready to deploy?** Just run:

```bash
./deploy-flyio.sh
```

Or follow steps 1-7 above! 🚀
