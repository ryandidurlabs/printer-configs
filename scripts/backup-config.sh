#!/bin/bash
# Backup Current Configuration Script
# Creates a timestamped backup of your current Klipper configuration

set -e

KLIPPER_CONFIG_DIR="$HOME/printer_data/config"
BACKUP_DIR="$HOME/printer_config_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Backup Printer Configuration"
echo "========================================="

# Check if config directory exists
if [ ! -d "$KLIPPER_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Warning: Klipper config directory not found at $KLIPPER_CONFIG_DIR${NC}"
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Creating backup..."
tar -czf "$BACKUP_FILE" -C "$KLIPPER_CONFIG_DIR" .

# Check if backup was successful
if [ -f "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo -e "${GREEN}Backup created successfully!${NC}"
    echo "  Location: $BACKUP_FILE"
    echo "  Size: $BACKUP_SIZE"
    
    # List recent backups
    echo ""
    echo "Recent backups:"
    ls -lh "$BACKUP_DIR" | tail -5
else
    echo "Error: Backup failed!"
    exit 1
fi

echo ""
echo "========================================="
echo "Backup complete!"
echo "========================================="
