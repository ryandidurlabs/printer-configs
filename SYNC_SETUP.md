# Complete GitHub and Pi Sync Setup Guide

This guide walks you through setting up GitHub and configuring each Raspberry Pi to automatically sync the correct configuration files.

## Part 1: Initial GitHub Setup (On Your Computer)

### Step 1: Initialize Git Repository Locally

Open a terminal in this directory (`Printer-1`) and run:

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: CR-10S printer configurations for both printers"
```

### Step 2: Create GitHub Repository

1. Go to https://github.com and sign in
2. Click the **+** icon in the top right → **New repository**
3. Fill in:
   - **Repository name**: `printer-configs` (or your preferred name)
   - **Description**: "CR-10S Printer Configurations - Klipper/MainsailOS"
   - **Visibility**: Choose **Private** (recommended) or **Public**
   - **DO NOT** check "Initialize with README" (we already have files)
4. Click **Create repository**

### Step 3: Connect and Push to GitHub

GitHub will show you commands. Use these (replace `YOUR_USERNAME` with your GitHub username):

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/printer-configs.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

You'll be prompted for your GitHub username and password. For better security, use a **Personal Access Token** instead of your password:
- GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
- Generate new token with `repo` permissions
- Use the token as your password

**Alternative: Use SSH (Recommended for Long-term)**

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your.email@example.com"
# Press Enter to accept defaults
# Copy the public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
# Then use SSH URL:
git remote set-url origin git@github.com:YOUR_USERNAME/printer-configs.git
git push -u origin main
```

## Part 2: Set Up Printer 1's Raspberry Pi

### Step 1: SSH into Printer 1's Pi

```bash
ssh pi@<printer1-ip-address>
# Default password: raspberry (change it!)
```

### Step 2: Install Git

```bash
# Update package list
sudo apt update

# Install git
sudo apt install -y git

# Configure git
git config --global user.name "Printer 1"
git config --global user.email "printer1@local"
```

### Step 3: Clone the Repository

```bash
# Navigate to home directory
cd ~

# Clone your repository
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config

# If using SSH:
# git clone git@github.com:YOUR_USERNAME/printer-configs.git printer-config
```

### Step 4: Create Sync Script for Printer 1

Create a script that copies Printer-1 configs to the correct location:

```bash
nano ~/sync-printer-config.sh
```

Paste this content:

```bash
#!/bin/bash
# Sync script for Printer 1
# Copies Printer-1 configuration files to Klipper config directory

set -e

CONFIG_DIR="$HOME/printer-config"
KLIPPER_CONFIG_DIR="$HOME/printer_data/config"
BACKUP_DIR="$HOME/printer_config_backups"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================="
echo "Syncing Printer 1 Configuration"
echo "========================================="

# Check if directories exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${RED}Error: Config directory not found${NC}"
    exit 1
fi

if [ ! -d "$KLIPPER_CONFIG_DIR" ]; then
    echo -e "${RED}Error: Klipper config directory not found${NC}"
    exit 1
fi

# Create backup
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/printer1_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
echo "Creating backup..."
tar -czf "$BACKUP_FILE" -C "$KLIPPER_CONFIG_DIR" . 2>/dev/null || true
echo -e "${GREEN}Backup created: $BACKUP_FILE${NC}"

# Pull latest from GitHub
echo "Pulling latest from GitHub..."
cd "$CONFIG_DIR"
git pull origin main

# Copy Printer-1 configuration files
echo "Copying Printer-1 configuration..."
cp "$CONFIG_DIR/Printer-1/printer.cfg" "$KLIPPER_CONFIG_DIR/printer.cfg"
cp "$CONFIG_DIR/Printer-1/macros.cfg" "$KLIPPER_CONFIG_DIR/macros.cfg"

echo -e "${GREEN}Configuration files synced!${NC}"

# Ask to restart Klipper
read -p "Restart Klipper service? (y/n): " restart
if [ "$restart" = "y" ] || [ "$restart" = "Y" ]; then
    echo "Restarting Klipper..."
    sudo systemctl restart klipper
    echo -e "${GREEN}Klipper restarted${NC}"
fi

echo "========================================="
echo "Sync complete!"
echo "========================================="
```

Save and exit (Ctrl+X, then Y, then Enter).

Make it executable:
```bash
chmod +x ~/sync-printer-config.sh
```

### Step 5: Initial Sync for Printer 1

```bash
# Run the sync script
~/sync-printer-config.sh
```

This will:
- Pull latest configs from GitHub
- Copy Printer-1 files to Klipper config directory
- Create a backup
- Optionally restart Klipper

## Part 3: Set Up Printer 2's Raspberry Pi

### Step 1: SSH into Printer 2's Pi

```bash
ssh pi@<printer2-ip-address>
```

### Step 2: Install Git

```bash
sudo apt update
sudo apt install -y git
git config --global user.name "Printer 2"
git config --global user.email "printer2@local"
```

### Step 3: Clone the Repository

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config
```

### Step 4: Create Sync Script for Printer 2

```bash
nano ~/sync-printer-config.sh
```

Paste this content (same as Printer 1, but copies Printer-2 files):

```bash
#!/bin/bash
# Sync script for Printer 2
# Copies Printer-2 configuration files to Klipper config directory

set -e

CONFIG_DIR="$HOME/printer-config"
KLIPPER_CONFIG_DIR="$HOME/printer_data/config"
BACKUP_DIR="$HOME/printer_config_backups"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================="
echo "Syncing Printer 2 Configuration"
echo "========================================="

# Check if directories exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${RED}Error: Config directory not found${NC}"
    exit 1
fi

if [ ! -d "$KLIPPER_CONFIG_DIR" ]; then
    echo -e "${RED}Error: Klipper config directory not found${NC}"
    exit 1
fi

# Create backup
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/printer2_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
echo "Creating backup..."
tar -czf "$BACKUP_FILE" -C "$KLIPPER_CONFIG_DIR" . 2>/dev/null || true
echo -e "${GREEN}Backup created: $BACKUP_FILE${NC}"

# Pull latest from GitHub
echo "Pulling latest from GitHub..."
cd "$CONFIG_DIR"
git pull origin main

# Copy Printer-2 configuration files
echo "Copying Printer-2 configuration..."
cp "$CONFIG_DIR/Printer-2/printer.cfg" "$KLIPPER_CONFIG_DIR/printer.cfg"
cp "$CONFIG_DIR/Printer-2/macros.cfg" "$KLIPPER_CONFIG_DIR/macros.cfg"

echo -e "${GREEN}Configuration files synced!${NC}"

# Ask to restart Klipper
read -p "Restart Klipper service? (y/n): " restart
if [ "$restart" = "y" ] || [ "$restart" = "Y" ]; then
    echo "Restarting Klipper..."
    sudo systemctl restart klipper
    echo -e "${GREEN}Klipper restarted${NC}"
fi

echo "========================================="
echo "Sync complete!"
echo "========================================="
```

Save and exit, then make executable:
```bash
chmod +x ~/sync-printer-config.sh
```

### Step 5: Initial Sync for Printer 2

```bash
~/sync-printer-config.sh
```

## Part 4: Daily Workflow

### Making Changes and Syncing

**On Your Computer:**

1. Make changes to configuration files
2. Test locally if possible
3. Commit and push:
   ```bash
   git add .
   git commit -m "Updated retraction settings for 0.8mm nozzle"
   git push origin main
   ```

**On Each Raspberry Pi:**

1. SSH into the Pi
2. Run the sync script:
   ```bash
   ~/sync-printer-config.sh
   ```
3. The script will:
   - Pull latest from GitHub
   - Copy the correct printer's config files
   - Create a backup
   - Optionally restart Klipper

### Quick Sync (Without Restart)

If you just want to pull and copy without restarting:

```bash
cd ~/printer-config
git pull origin main

# For Printer 1:
cp Printer-1/printer.cfg ~/printer_data/config/
cp Printer-1/macros.cfg ~/printer_data/config/

# For Printer 2:
cp Printer-2/printer.cfg ~/printer_data/config/
cp Printer-2/macros.cfg ~/printer_data/config/
```

## Part 5: Optional - Automatic Sync (Advanced)

**Warning:** Only enable this if you're comfortable with automatic updates. It can interrupt prints if not configured carefully.

### Option A: Cron Job (Pulls but doesn't restart)

```bash
# Edit crontab
crontab -e

# Add this line to pull every hour (but don't restart)
0 * * * * cd ~/printer-config && git pull origin main > /dev/null 2>&1
```

### Option B: Smart Sync Script (Checks if printing)

Create a smarter sync script that only restarts if not printing:

```bash
nano ~/smart-sync.sh
```

```bash
#!/bin/bash
# Smart sync - only restarts if printer is idle

CONFIG_DIR="$HOME/printer-config"
KLIPPER_CONFIG_DIR="$HOME/printer_data/config"

cd "$CONFIG_DIR"
git pull origin main

# Copy configs (Printer 1 or 2 - adjust as needed)
cp Printer-1/printer.cfg "$KLIPPER_CONFIG_DIR/printer.cfg"
cp Printer-1/macros.cfg "$KLIPPER_CONFIG_DIR/macros.cfg"

# Check if printer is printing (via Moonraker API)
STATUS=$(curl -s http://localhost:7125/printer/objects/query?print_stats | grep -o '"state":"[^"]*"' | cut -d'"' -f4)

if [ "$STATUS" != "printing" ] && [ "$STATUS" != "paused" ]; then
    echo "Printer is idle, restarting Klipper..."
    sudo systemctl restart klipper
else
    echo "Printer is active, skipping restart. Restart manually when done."
fi
```

## Part 6: Troubleshooting

### Authentication Issues

**HTTPS Password Issues:**
- Use a Personal Access Token instead of password
- Or switch to SSH authentication

**SSH Key Issues:**
```bash
# Test SSH connection
ssh -T git@github.com

# If it fails, add your SSH key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Sync Script Fails

```bash
# Check if directories exist
ls -la ~/printer-config
ls -la ~/printer_data/config

# Check git status
cd ~/printer-config
git status

# Check permissions
ls -la ~/sync-printer-config.sh
```

### Wrong Files Synced

Double-check which printer you're on:
```bash
# Check which configs are in the directory
ls -la ~/printer-config/Printer-*

# Verify current config
cat ~/printer_data/config/printer.cfg | head -5
```

### Merge Conflicts

If you have local changes that conflict:
```bash
cd ~/printer-config
git stash  # Save local changes
git pull origin main
git stash pop  # Reapply (resolve conflicts if needed)
```

## Summary

**Initial Setup:**
1. ✅ Initialize git locally and push to GitHub
2. ✅ Clone repo on each Pi
3. ✅ Create sync script on each Pi
4. ✅ Run initial sync

**Daily Use:**
1. Make changes locally → commit → push
2. Run `~/sync-printer-config.sh` on each Pi
3. Configs automatically go to correct locations

**File Locations:**
- GitHub repo: Contains both `Printer-1/` and `Printer-2/` configs
- Printer 1 Pi: `~/printer-config/Printer-1/` → `~/printer_data/config/`
- Printer 2 Pi: `~/printer-config/Printer-2/` → `~/printer_data/config/`

You're all set! Each Pi will pull from the same repo but sync only its own configuration files.
