# ============================================================
#   DG_SMART_PREDICTION — PRODUCTION DEPLOYMENT GUIDE
#   Ubuntu 24.04 · Nginx · SSL · Systemd · UFW
#   VPS IP: 82.112.238.89
# ============================================================
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 1 — CONNECT & UPDATE SERVER
═══════════════════════════════════════════════════════════════
 
# Connect to your VPS
ssh root@82.112.238.89
 
# Update system packages
apt update && apt upgrade -y
 
# Restart if prompted (*** System restart required ***)
reboot
 
# Reconnect after reboot
ssh root@82.112.238.89
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 2 — INSTALL PYTHON & SYSTEM DEPENDENCIES
═══════════════════════════════════════════════════════════════
 
apt install -y python3 python3-pip python3-venv python3-dev \
               nginx certbot python3-certbot-nginx \
               git curl ufw build-essential
 
# Verify Python version (should be 3.12.x on Ubuntu 24.04)
python3 --version
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 3 — CREATE DEDICATED APP USER (Security Best Practice)
═══════════════════════════════════════════════════════════════
 
# Create a non-root user to run the app
adduser --system --group --no-create-home dg_smart_prediction
 
# Create app directory
mkdir -p /var/www/dg_smart_prediction
chown dg_smart_prediction:dg_smart_prediction /var/www/dg_smart_prediction
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 4 — UPLOAD YOUR PROJECT TO VPS
═══════════════════════════════════════════════════════════════
 
# OPTION A — If your code is on GitHub (recommended)
cd /var/www/dg_smart_prediction
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git .
 
# OPTION B — Upload from your local machine using SCP
# Run this on your LOCAL machine (Windows PowerShell):
scp -r C:\path\to\career_prediction root@82.112.238.89:/var/www/dg_smart_prediction/
 
# OPTION C — Using SFTP client like WinSCP or FileZilla
# Host: 82.112.238.89 | User: root | Port: 22
# Upload folder to: /var/www/dg_smart_prediction/
 
# After upload, verify files are present
ls /var/www/dg_smart_prediction/
# Should show: main.py  requirements.txt  app/  database/  .env.example
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 5 — SETUP PYTHON VIRTUAL ENVIRONMENT
═══════════════════════════════════════════════════════════════
 
cd /var/www/dg_smart_prediction
 
# Create virtual environment
python3 -m venv venv
 
# Activate it
source venv/bin/activate
 
# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt
 
# Verify FastAPI and Groq are installed
pip show fastapi groq uvicorn
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 6 — CONFIGURE ENVIRONMENT VARIABLES
═══════════════════════════════════════════════════════════════
 
# Create the .env file (NEVER commit this to git)
nano /var/www/dg_smart_prediction/.env
 
# Paste this content (replace with your actual Groq API key):
# ─────────────────────────────────────────────
GROQ_API_KEY=gsk_your_actual_groq_api_key_here
APP_HOST=0.0.0.0
APP_PORT=8000
APP_ENV=production
# ─────────────────────────────────────────────
# Save: Ctrl+O → Enter → Ctrl+X
 
# Lock down permissions (only owner can read)
chmod 600 /var/www/dg_smart_prediction/.env
 
# Set ownership
chown -R dg_smart_prediction:dg_smart_prediction /var/www/dg_smart_prediction
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 7 — TEST THE APP MANUALLY FIRST
═══════════════════════════════════════════════════════════════
 
cd /var/www/dg_smart_prediction
source venv/bin/activate
 
# Run once to verify it starts without errors
uvicorn app.main:app --host 0.0.0.0 --port 8000
 
# You should see:
# INFO: Started server process
# INFO: Waiting for application startup.
# ✅ Database initialized successfully
# INFO: Application startup complete.
# INFO: Uvicorn running on http://0.0.0.0:8000
 
# Press Ctrl+C to stop after confirming it works
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 8 — CREATE SYSTEMD SERVICE (Auto-start + Auto-restart)
═══════════════════════════════════════════════════════════════
 
# Create the service file
nano /etc/systemd/system/dg_smart_prediction.service
 
# Paste this EXACT content:
# ─────────────────────────────────────────────
[Unit]
Description=DG_Smart_prediction Career Prediction API
After=network.target
Wants=network-online.target
 
[Service]
Type=simple
User=dg_smart_prediction
Group=dg_smart_prediction
WorkingDirectory=/var/www/dg_smart_prediction
EnvironmentFile=/var/www/dg_smart_prediction/.env
ExecStart=/var/www/dg_smart_prediction/venv/bin/uvicorn app.main:app \
          --host 0.0.0.0 \
          --port 8000 \
          --workers 2 \
          --log-level info \
          --access-log
ExecReload=/bin/kill -s HUP $MAINPID
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=dg_smart_prediction
 
[Install]
WantedBy=multi-user.target
# ───────────────────────────────────────────── 
# Save: Ctrl+O → Enter → Ctrl+X
 
# Reload systemd and enable the service
systemctl daemon-reload
systemctl enable dg_smart_prediction
systemctl start dg_smart_prediction
 
# Check status
systemctl status dg_smart_prediction
 
# You should see: ● dg_smart_prediction.service - Active: active (running)
 
# View live logs
journalctl -u dg_smart_prediction -f
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 9 — CONFIGURE UFW FIREWALL
═══════════════════════════════════════════════════════════════
 
# Allow SSH (CRITICAL — do this first or you'll be locked out!)
ufw allow OpenSSH
 
# Allow HTTP and HTTPS
ufw allow 'Nginx Full'
 
# Enable firewall
ufw enable
# Type 'y' when prompted
 
# Verify rules
ufw status verbose
 
# Expected output:
# To                         Action      From
# --                         ------      ----
# OpenSSH                    ALLOW IN    Anywhere
# Nginx Full                 ALLOW IN    Anywhere
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 10 — CONFIGURE NGINX REVERSE PROXY
═══════════════════════════════════════════════════════════════
 
# Remove default nginx site
rm /etc/nginx/sites-enabled/default
 
# Create your app's nginx config
nano /etc/nginx/sites-available/dg_smart_prediction
 
# Paste this content:
# ─────────────────────────────────────────────
server {
    listen 80;
    server_name 82.112.238.89;   # Replace with your domain if you have one
 
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
 
    # Increase timeout for Groq AI calls (can take 10-30 seconds)
    proxy_read_timeout 120s;
    proxy_connect_timeout 10s;
    proxy_send_timeout 120s;
 
    # Max request body size (for large answer submissions)
    client_max_body_size 10M;
 
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
 
    # Block access to .env and hidden files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
# ─────────────────────────────────────────────
# Save: Ctrl+O → Enter → Ctrl+X
 
# Enable the site
ln -s /etc/nginx/sites-available/dg_smart_prediction /etc/nginx/sites-enabled/
 
# Test nginx config for syntax errors
nginx -t
# Should show: syntax is ok + test is successful
 
# Restart nginx
systemctl restart nginx
systemctl enable nginx
 
# Test your API is accessible on port 80
curl http://82.112.238.89/
# Should return: {"app":"Antigravity — Career Prediction AI",...}
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 11 — SSL / HTTPS WITH LET'S ENCRYPT
═══════════════════════════════════════════════════════════════
 
# ⚠️  IMPORTANT: SSL requires a DOMAIN NAME pointed to your VPS IP.
#     If you only have an IP (82.112.238.89) and no domain, SKIP this step.
#     Let's Encrypt does NOT issue certificates for bare IP addresses.
 
# IF YOU HAVE A DOMAIN (e.g. api.dg_smart_prediction.in):
# ─────────────────────────────────────────────
# Step 1: Go to your domain registrar (GoDaddy/Hostinger/etc.)
#         Add an A Record:  api.dg_smart_prediction.in  →  82.112.238.89
#         Wait 5–30 minutes for DNS to propagate
 
# Step 2: Update nginx config — replace server_name
sed -i 's/server_name 82.112.238.89;/server_name api.dg_smart_prediction.in;/' \
    /etc/nginx/sites-available/dg_smart_prediction
nginx -t && systemctl reload nginx
 
# Step 3: Get SSL certificate
certbot --nginx -d api.dg_smart_prediction.in \
        --non-interactive \
        --agree-tos \
        --email your-email@gmail.com \
        --redirect
 
# Certbot will automatically:
#   - Get SSL certificate from Let's Encrypt
#   - Update your nginx config to use HTTPS
#   - Redirect HTTP → HTTPS
#   - Set up auto-renewal
 
# Step 4: Verify auto-renewal works
certbot renew --dry-run
 
# After SSL, your API is at:
# https://api.dg_smart_prediction.in/docs
 
# ─────────────────────────────────────────────
# IF YOU ONLY HAVE IP (no domain):
# ─────────────────────────────────────────────
# Your API works on:  http://82.112.238.89/
# Swagger docs at:    http://82.112.238.89/docs
# No SSL possible without a domain.
 
 
 
═══════════════════════════════════════════════════════════════
  STEP 12 — VERIFY EVERYTHING IS WORKING
═══════════════════════════════════════════════════════════════
 
# 1. Check all services are running
systemctl status dg_smart_prediction     # Should be: active (running)
systemctl status nginx                   # Should be: active (running)

# 2. Test the health endpoint
curl http://82.112.238.89/api/health
# Should return: {"status": "healthy"}
