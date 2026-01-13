#!/bin/bash
# Script to add SSH public key to Raspberry Pi
# Run this on each Pi: bash <(curl -s https://raw.githubusercontent.com/ryandidurlabs/printer-configs/main/setup-ssh-keys.sh) YOUR_PUBLIC_KEY

PUBLIC_KEY="$1"

if [ -z "$PUBLIC_KEY" ]; then
    echo "Usage: $0 <public_key>"
    echo "Example: $0 'ssh-ed25519 AAAAC3... user@host'"
    exit 1
fi

# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add key to authorized_keys
echo "$PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo "SSH key added successfully!"
echo "You can now SSH without a password."
