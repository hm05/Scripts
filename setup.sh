#!/bin/bash

# Check if the script is run as root
if [ "$(whoami)" != "root" ]; then
    echo "Please run the script as root user"
    exit 1
fi

# Update and upgrade the system
apt update
apt -y upgrade
apt -y full-upgrade
apt -y autoremove

# Install Armitage and start PostgreSQL service
apt install -y armitage
/etc/init.d/postgresql start

# Initialize Metasploit database
msfdb init

# Download and install Obsidian
curl -L -o obsidian_1.8.9_amd64.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.9/obsidian_1.8.9_amd64.deb
dpkg -i obsidian_1.8.9_amd64.deb

# Final message
echo "Your system is ready to use"
