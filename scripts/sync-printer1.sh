#!/bin/bash
# Sync script for Printer 1
# Copies Printer-1 configuration files to Klipper config directory
# Usage: ~/sync-printer-config.sh

set -e

CONFIG_DIR="$HOME/printer-config"
KLIPPER_CONFIG_DIR="$HOME/printer_data/config"
BACKUP_DIR="$HOME/printer_config_backups"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "Syncing Printer 1 Configuration"
echo "========================================="

# Check if directories exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${RED}Error: Config directory not found at $CONFIG_DIR${NC}"
    echo "Please clone your repository first:"
    echo "  git clone <your-repo-url> ~/printer-config"
    exit 1
fi

if [ ! -d "$KLIPPER_CONFIG_DIR" ]; then
    echo -e "${RED}Error: Klipper config directory not found at $KLIPPER_CONFIG_DIR${NC}"
    echo "Is Klipper installed? Check MainsailOS setup."
    exit 1
fi

# Create backup
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/printer1_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
echo -e "${BLUE}Creating backup...${NC}"
tar -czf "$BACKUP_FILE" -C "$KLIPPER_CONFIG_DIR" . 2>/dev/null || true
if [ -f "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo -e "${GREEN}Backup created: $BACKUP_FILE (Size: $BACKUP_SIZE)${NC}"
else
    echo -e "${YELLOW}Warning: Backup creation may have failed${NC}"
fi

# Pull latest from GitHub
echo -e "${BLUE}Pulling latest from GitHub...${NC}"
cd "$CONFIG_DIR"
git fetch origin

# Check if there are updates
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null || echo "")
BASE=$(git merge-base @ @{u} 2>/dev/null || echo "")

if [ -z "$REMOTE" ]; then
    echo -e "${YELLOW}No remote tracking branch set. Pulling anyway...${NC}"
    git pull origin main || git pull origin master
elif [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}Already up to date.${NC}"
else
    echo -e "${YELLOW}Updates available. Pulling...${NC}"
    git pull origin main || git pull origin master
fi

# Verify Printer-1 directory exists
if [ ! -d "$CONFIG_DIR/Printer-1" ]; then
    echo -e "${RED}Error: Printer-1 directory not found in repository${NC}"
    exit 1
fi

# Copy Printer-1 configuration files
echo -e "${BLUE}Copying Printer-1 configuration files...${NC}"
cp "$CONFIG_DIR/Printer-1/printer.cfg" "$KLIPPER_CONFIG_DIR/printer.cfg"
if [ -f "$CONFIG_DIR/Printer-1/macros.cfg" ]; then
    cp "$CONFIG_DIR/Printer-1/macros.cfg" "$KLIPPER_CONFIG_DIR/macros.cfg"
fi

echo -e "${GREEN}Configuration files synced!${NC}"
echo ""
echo "Files copied:"
echo "  - printer.cfg"
[ -f "$CONFIG_DIR/Printer-1/macros.cfg" ] && echo "  - macros.cfg"

# Ask to restart Klipper
echo ""
read -p "Restart Klipper service? (y/n): " restart
if [ "$restart" = "y" ] || [ "$restart" = "Y" ]; then
    echo -e "${BLUE}Restarting Klipper...${NC}"
    sudo systemctl restart klipper
    sleep 2
    if sudo systemctl is-active --quiet klipper; then
        echo -e "${GREEN}Klipper restarted successfully${NC}"
    else
        echo -e "${RED}Warning: Klipper may not have started. Check status:${NC}"
        echo "  sudo systemctl status klipper"
    fi
else
    echo -e "${YELLOW}Klipper not restarted. Restart manually when ready:${NC}"
    echo "  sudo systemctl restart klipper"
fi

echo ""
echo "========================================="
echo -e "${GREEN}Sync complete!${NC}"
echo "========================================="
