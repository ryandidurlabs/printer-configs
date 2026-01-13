#!/bin/bash
# Pull Latest Configuration Script
# This script pulls the latest configuration from git and optionally restarts Klipper

set -e

CONFIG_DIR="$HOME/printer-config"
KLIPPER_CONFIG_DIR="$HOME/printer_data/config"
BACKUP_DIR="$HOME/printer_config_backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Pull Printer Configuration"
echo "========================================="

# Check if config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${RED}Error: Configuration directory not found at $CONFIG_DIR${NC}"
    echo "Please clone your repository first:"
    echo "  git clone <your-repo-url> ~/printer-config"
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/config_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Backup current configuration
echo "Creating backup of current configuration..."
if [ -d "$KLIPPER_CONFIG_DIR" ]; then
    tar -czf "$BACKUP_FILE" -C "$KLIPPER_CONFIG_DIR" . 2>/dev/null || true
    echo -e "${GREEN}Backup created: $BACKUP_FILE${NC}"
else
    echo -e "${YELLOW}Warning: Klipper config directory not found, skipping backup${NC}"
fi

# Change to config directory
cd "$CONFIG_DIR"

# Check git status
echo ""
echo "Checking git status..."
git fetch origin

# Show what will be updated
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}Configuration is up to date.${NC}"
    exit 0
elif [ "$LOCAL" = "$BASE" ]; then
    echo -e "${YELLOW}Updates available. Pulling latest changes...${NC}"
    git pull origin main
    
    # Determine which printer config to use
    echo ""
    read -p "Which printer config to use? (1 or 2): " printer_num
    
    if [ "$printer_num" = "1" ]; then
        PRINTER_DIR="Printer-1"
    elif [ "$printer_num" = "2" ]; then
        PRINTER_DIR="Printer-2"
    else
        echo -e "${RED}Invalid selection. Exiting.${NC}"
        exit 1
    fi
    
    # Copy configuration files
    if [ -d "$PRINTER_DIR" ]; then
        echo "Copying configuration files from $PRINTER_DIR..."
        cp "$PRINTER_DIR/printer.cfg" "$KLIPPER_CONFIG_DIR/" 2>/dev/null || true
        cp "$PRINTER_DIR/macros.cfg" "$KLIPPER_CONFIG_DIR/" 2>/dev/null || true
        echo -e "${GREEN}Configuration files copied.${NC}"
    else
        echo -e "${RED}Error: $PRINTER_DIR directory not found${NC}"
        exit 1
    fi
    
    # Ask to restart Klipper
    echo ""
    read -p "Restart Klipper service? (y/n): " restart_klipper
    if [ "$restart_klipper" = "y" ] || [ "$restart_klipper" = "Y" ]; then
        echo "Restarting Klipper..."
        sudo systemctl restart klipper
        echo -e "${GREEN}Klipper restarted.${NC}"
    fi
    
elif [ "$REMOTE" = "$BASE" ]; then
    echo -e "${RED}Your local configuration has commits that haven't been pushed.${NC}"
    echo "Please review and merge manually."
    exit 1
else
    echo -e "${RED}Configuration has diverged. Manual merge required.${NC}"
    exit 1
fi

echo ""
echo "========================================="
echo "Configuration update complete!"
echo "========================================="
