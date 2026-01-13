# Quick Sync Setup Guide - Step by Step

This is a simplified, copy-paste guide to get everything syncing correctly.

## Step 1: Set Up GitHub (On Your Computer)

### 1.1 Initialize Git Locally

Open PowerShell or Terminal in this directory and run:

```powershell
# Initialize git
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: CR-10S printer configurations"
```

### 1.2 Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `printer-configs`
3. Description: "CR-10S Printer Configurations"
4. Choose **Private** (recommended)
5. **DO NOT** check "Initialize with README"
6. Click **Create repository**

### 1.3 Push to GitHub

GitHub will show you commands. Use these (replace `YOUR_USERNAME`):

```powershell
# Add remote
git remote add origin https://github.com/YOUR_USERNAME/printer-configs.git

# Rename branch
git branch -M main

# Push to GitHub
git push -u origin main
```

**Note:** You'll need a Personal Access Token instead of password:
- GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
- Generate new token with `repo` scope
- Use token as password when pushing

## Step 2: Set Up Printer 1's Raspberry Pi

### 2.1 SSH and Install Git

```bash
# SSH into Printer 1's Pi
ssh pi@<printer1-ip>

# Install git
sudo apt update
sudo apt install -y git

# Configure git
git config --global user.name "Printer 1"
git config --global user.email "printer1@local"
```

### 2.2 Clone Repository

```bash
# Clone your repo
cd ~
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config
```

### 2.3 Install Sync Script

```bash
# Copy the sync script to home directory
cp ~/printer-config/scripts/sync-printer1.sh ~/sync-printer-config.sh

# Make it executable
chmod +x ~/sync-printer-config.sh
```

### 2.4 Run Initial Sync

```bash
# Run the sync script
~/sync-printer-config.sh
```

This will:
- ✅ Pull latest from GitHub
- ✅ Copy Printer-1 files to `~/printer_data/config/`
- ✅ Create a backup
- ✅ Optionally restart Klipper

## Step 3: Set Up Printer 2's Raspberry Pi

### 3.1 SSH and Install Git

```bash
# SSH into Printer 2's Pi
ssh pi@<printer2-ip>

# Install git
sudo apt update
sudo apt install -y git

# Configure git
git config --global user.name "Printer 2"
git config --global user.email "printer2@local"
```

### 3.2 Clone Repository

```bash
# Clone your repo
cd ~
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config
```

### 3.3 Install Sync Script

```bash
# Copy the sync script to home directory
cp ~/printer-config/scripts/sync-printer2.sh ~/sync-printer-config.sh

# Make it executable
chmod +x ~/sync-printer-config.sh
```

### 3.4 Run Initial Sync

```bash
# Run the sync script
~/sync-printer-config.sh
```

This will:
- ✅ Pull latest from GitHub
- ✅ Copy Printer-2 files to `~/printer_data/config/`
- ✅ Create a backup
- ✅ Optionally restart Klipper

## Step 4: Daily Workflow

### Making Changes

**On Your Computer:**

1. Edit configuration files in `Printer-1/` or `Printer-2/`
2. Commit and push:
   ```powershell
   git add .
   git commit -m "Updated retraction settings"
   git push origin main
   ```

### Syncing to Printers

**On Each Raspberry Pi:**

```bash
# Just run the sync script
~/sync-printer-config.sh
```

The script automatically:
- Pulls latest from GitHub
- Copies the correct printer's config files
- Creates a backup
- Asks if you want to restart Klipper

## File Structure Summary

```
GitHub Repository (printer-configs)
├── Printer-1/
│   ├── printer.cfg    → Copied to Printer 1 Pi: ~/printer_data/config/printer.cfg
│   └── macros.cfg     → Copied to Printer 1 Pi: ~/printer_data/config/macros.cfg
└── Printer-2/
    ├── printer.cfg    → Copied to Printer 2 Pi: ~/printer_data/config/printer.cfg
    └── macros.cfg     → Copied to Printer 2 Pi: ~/printer_data/config/macros.cfg
```

## Quick Commands Reference

### On Your Computer
```powershell
# Make changes, then:
git add .
git commit -m "Description of changes"
git push origin main
```

### On Printer 1 Pi
```bash
~/sync-printer-config.sh
```

### On Printer 2 Pi
```bash
~/sync-printer-config.sh
```

## Troubleshooting

### "Permission denied" when running script
```bash
chmod +x ~/sync-printer-config.sh
```

### "Config directory not found"
```bash
# Make sure you cloned the repo
cd ~
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config
```

### "Klipper config directory not found"
```bash
# Check if Klipper is installed
ls ~/printer_data/config/
# If it doesn't exist, check MainsailOS setup
```

### Authentication errors
```bash
# For HTTPS, use Personal Access Token
# Or set up SSH keys (see SYNC_SETUP.md)
```

## That's It!

You're all set! Each Pi will:
- Pull from the same GitHub repo
- Automatically copy only its own config files
- Keep backups of previous configs
- Restart Klipper when you choose

Just remember:
- **Printer 1** uses `sync-printer1.sh` → copies `Printer-1/` files
- **Printer 2** uses `sync-printer2.sh` → copies `Printer-2/` files
