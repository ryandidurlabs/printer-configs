#!/bin/bash
# Setup script for Printer 1's Raspberry Pi
# Run this on the Pi: bash <(curl -s https://raw.githubusercontent.com/ryandidurlabs/printer-configs/main/setup-printer1-pi.sh)
# Or copy-paste these commands

set -e

echo "========================================="
echo "Setting up Printer 1's Raspberry Pi"
echo "========================================="

# Update and install git
echo "Installing git..."
sudo apt update
sudo apt install -y git

# Configure git
echo "Configuring git..."
git config --global user.name "Printer 1"
git config --global user.email "printer1@local"

# Clone repository
echo "Cloning repository..."
cd ~
if [ -d "printer-config" ]; then
    echo "Repository already exists, pulling latest..."
    cd printer-config
    git pull origin main
else
    git clone https://github.com/ryandidurlabs/printer-configs.git printer-config
fi

# Copy Printer-1 configuration files
echo "Copying Printer-1 configuration files..."
cp ~/printer-config/Printer-1/printer.cfg ~/printer_data/config/printer.cfg
cp ~/printer-config/Printer-1/macros.cfg ~/printer_data/config/macros.cfg

# Install sync script
echo "Installing sync script..."
cp ~/printer-config/scripts/sync-printer1.sh ~/sync-printer-config.sh
chmod +x ~/sync-printer-config.sh

# Check serial port
echo ""
echo "========================================="
echo "Checking available serial ports..."
echo "========================================="
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || echo "No USB/ACM devices found"

echo ""
echo "========================================="
echo "Setup complete!"
echo "========================================="
echo ""
echo "IMPORTANT: Update the serial port in printer.cfg:"
echo "  nano ~/printer_data/config/printer.cfg"
echo ""
echo "Find [mcu] section and update 'serial:' with the correct port"
echo ""
echo "Then restart Klipper:"
echo "  sudo systemctl restart klipper"
echo ""
echo "Check status:"
echo "  sudo systemctl status klipper"
echo ""
