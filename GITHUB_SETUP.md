# GitHub Repository Setup Guide

This guide will help you set up GitHub repositories for your printer configurations and configure each Raspberry Pi to pull from them.

## Option 1: Single Repository (Recommended)

This is the simplest approach - one repository containing both printer configurations.

### Step 1: Create GitHub Repository

1. Go to GitHub.com and sign in
2. Click the **+** icon → **New repository**
3. Repository name: `printer-configs` (or your preferred name)
4. Description: "CR-10S Printer Configurations - Klipper/MainsailOS"
5. Set to **Private** (recommended for personal configs)
6. **Do NOT** initialize with README (we already have one)
7. Click **Create repository**

### Step 2: Push This Repository to GitHub

On your local machine (where you created these files):

```bash
# Initialize git repository (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: CR-10S printer configurations"

# Add remote repository (replace with your GitHub URL)
git remote add origin https://github.com/YOUR_USERNAME/printer-configs.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Set Up Each Raspberry Pi

**For Printer 1's Raspberry Pi:**

```bash
# SSH into the Pi
ssh pi@<printer1-ip>

# Clone the repository
cd ~
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config

# Copy Printer-1 configuration
cp ~/printer-config/Printer-1/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-1/macros.cfg ~/printer_data/config/

# Restart Klipper
sudo systemctl restart klipper
```

**For Printer 2's Raspberry Pi:**

```bash
# SSH into the Pi
ssh pi@<printer2-ip>

# Clone the repository
cd ~
git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config

# Copy Printer-2 configuration
cp ~/printer-config/Printer-2/printer.cfg ~/printer_data/config/
cp ~/printer-config/Printer-2/macros.cfg ~/printer_data/config/

# Restart Klipper
sudo systemctl restart klipper
```

## Option 2: Separate Repositories (Alternative)

If you prefer separate repositories for each printer:

### Create Two Repositories

1. **printer-1-config** - For first printer
2. **printer-2-config** - For second printer

### Set Up Each Repository

**For Printer 1 repository:**
```bash
# Create new directory
mkdir printer-1-config
cd printer-1-config

# Copy Printer-1 files
cp -r ../Printer-1/* .

# Initialize git
git init
git add .
git commit -m "Initial commit: Printer 1 configuration"

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/printer-1-config.git
git branch -M main
git push -u origin main
```

**For Printer 2 repository:**
```bash
# Create new directory
mkdir printer-2-config
cd printer-2-config

# Copy Printer-2 files
cp -r ../Printer-2/* .

# Initialize git
git init
git add .
git commit -m "Initial commit: Printer 2 configuration"

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/printer-2-config.git
git branch -M main
git push -u origin main
```

## Setting Up Git on Raspberry Pi

### Method 1: Using the Install Script

```bash
# SSH into Pi
ssh pi@<pi-ip>

# Download and run install script
cd ~
wget https://raw.githubusercontent.com/YOUR_USERNAME/printer-configs/main/scripts/install-git.sh
chmod +x install-git.sh
./install-git.sh
```

### Method 2: Manual Setup

```bash
# Install git
sudo apt update
sudo apt install -y git

# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
```

## Pulling Updates on Raspberry Pi

### Method 1: Using the Pull Script

```bash
# Make script executable (first time only)
chmod +x ~/printer-config/scripts/pull-config.sh

# Run the script
~/printer-config/scripts/pull-config.sh
```

### Method 2: Manual Pull

```bash
cd ~/printer-config
git pull origin main

# Copy updated configs
cp Printer-1/printer.cfg ~/printer_data/config/  # For Printer 1
# OR
cp Printer-2/printer.cfg ~/printer_data/config/  # For Printer 2

# Restart Klipper
sudo systemctl restart klipper
```

## Automatic Updates (Optional)

Set up a cron job to automatically pull updates:

```bash
# Edit crontab
crontab -e

# Add this line to pull every hour (be careful - test first!)
0 * * * * cd ~/printer-config && git pull origin main && sudo systemctl restart klipper
```

**Warning:** Automatic restarts can interrupt prints. Consider:
- Only pulling configs automatically (don't restart)
- Using a script that checks if printer is idle before restarting
- Pulling updates manually when needed

## Authentication

### Using HTTPS (Simple)

GitHub will prompt for username and password/token. For better security, use a Personal Access Token instead of password.

### Using SSH Keys (Recommended)

1. **Generate SSH key on Pi:**
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
# Press Enter to accept default location
# Optionally set a passphrase
```

2. **Copy public key:**
```bash
cat ~/.ssh/id_ed25519.pub
```

3. **Add to GitHub:**
   - Go to GitHub → Settings → SSH and GPG keys
   - Click "New SSH key"
   - Paste your public key
   - Save

4. **Update remote URL:**
```bash
cd ~/printer-config
git remote set-url origin git@github.com:YOUR_USERNAME/printer-configs.git
```

## Best Practices

1. **Always backup before pulling:** Use the backup script before updating
2. **Test changes:** Make changes on one printer first, test, then apply to the other
3. **Commit often:** Commit calibration changes and improvements
4. **Use meaningful commit messages:** "Calibrated E-steps for Printer 1" vs "updated config"
5. **Keep local overrides separate:** If you need printer-specific tweaks, document them in the README

## Troubleshooting

### Permission Denied
```bash
# Fix file permissions
sudo chown -R $USER:$USER ~/printer-config
```

### Merge Conflicts
If you have local changes that conflict:
```bash
cd ~/printer-config
git stash  # Save local changes
git pull origin main
git stash pop  # Reapply local changes
# Resolve conflicts manually if needed
```

### Can't Connect to GitHub
- Check internet connection: `ping github.com`
- Verify SSH key is added to GitHub
- Check firewall settings

## Workflow Example

1. **Make changes locally** (on your computer)
2. **Test on Printer 1** (copy config, test print)
3. **Commit and push:**
   ```bash
   git add .
   git commit -m "Updated retraction settings for 0.8mm nozzle"
   git push origin main
   ```
4. **Pull on Printer 1's Pi:**
   ```bash
   cd ~/printer-config
   git pull origin main
   cp Printer-1/printer.cfg ~/printer_data/config/
   sudo systemctl restart klipper
   ```
5. **If successful, apply to Printer 2** (same process)
