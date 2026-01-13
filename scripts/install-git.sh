#!/bin/bash
# Git Installation and Setup Script for Raspberry Pi
# Run this script on each Raspberry Pi to set up git for pulling configurations

set -e

echo "========================================="
echo "Git Setup for Printer Configuration"
echo "========================================="

# Update package list
echo "Updating package list..."
sudo apt update

# Install git if not already installed
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo apt install -y git
else
    echo "Git is already installed."
fi

# Configure git (user will need to provide these)
echo ""
echo "Git Configuration"
echo "-----------------"
read -p "Enter your name for git commits: " git_name
read -p "Enter your email for git commits: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"

# Set default branch name
git config --global init.defaultBranch main

# Optional: Set up credential helper to cache credentials
echo ""
read -p "Set up credential caching? (y/n): " setup_cache
if [ "$setup_cache" = "y" ] || [ "$setup_cache" = "Y" ]; then
    git config --global credential.helper 'cache --timeout=3600'
    echo "Credential caching enabled (1 hour timeout)."
fi

# Display git configuration
echo ""
echo "Git Configuration Summary:"
echo "-------------------------"
git config --list --global

echo ""
echo "========================================="
echo "Git setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Clone your configuration repository:"
echo "   git clone <your-repo-url> ~/printer-config"
echo "2. Copy configuration files to Klipper config directory"
echo "3. Restart Klipper service"
