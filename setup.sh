#!/bin/bash

# Check if the script is being run as root
if [ "$(whoami)" != "root" ]; then
    cat << "EOF"
       ____  __    __  ____  ____  ____ 
      (  __)(  )  (  )(  _ \(  __)(  _ \
       ) _) / (_/\ )(  ) __/ ) _)  )   /
      (____)\____/(__)(__)  (____)(__\_)
Please run the script as root user
EOF
    exit 1
fi

# Update and upgrade the system
apt update
apt -y upgrade
apt -y full-upgrade
apt -y autoremove

# Install Armitage and initialize PostgreSQL database for Metasploit
apt install -y armitage
/etc/init.d/postgresql start
msfdb init

# Check system architecture and download appropriate Obsidian version
if [ "$(uname -m)" == "aarch64" ]; then
    curl -L -o Obsidian-1.8.9-arm64.AppImage https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.9/Obsidian-1.8.9-arm64.AppImage
    chmod u+x Obsidian-1.8.9-arm64.AppImage
else
    curl -L -o Obsidian-1.8.9.AppImage https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.9/Obsidian-1.8.9.AppImage
    chmod u+x Obsidian-1.8.9.AppImage
fi

cat << "EOF"
   ____  __    ___  _  _ ____ 
  (  __)(  )  / __)/ )( (  _ \
   ) _) / (_/\__ \) \/ (    /
  (____)\____(____)\____(__\_)
Your system is ready to use!
EOF

# Self-destruct mechanism: Delete the script after execution
rm -- "$0"
