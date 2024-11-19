#!/bin/bash

set -e

echo "=== AirPlay Receiver Bootstrap ==="
echo "This script will install and configure UxPlay for automatic AirPlay reception"
echo

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "Please run this script as a regular user with sudo privileges"
   echo "Usage: ./bootstrap.sh"
   exit 1
fi

# Get current user
CURRENT_USER=$(whoami)
echo "Setting up for user: $CURRENT_USER"

# Step 1: Install required packages
echo "Step 1: Installing required packages..."
sudo apt update
sudo apt install -y xfce4 lightdm
sudo apt install -y build-essential pkg-config cmake git
sudo apt install -y libssl-dev libplist-dev libavahi-compat-libdnssd-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt install -y gstreamer1.0-libav gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
sudo apt install -y feh unclutter imagemagick

# Step 2: Install UxPlay
echo "Step 2: Installing UxPlay..."
cd /tmp
if [ -d "UxPlay" ]; then
    rm -rf UxPlay
fi
git clone https://github.com/FDH2/UxPlay.git
cd UxPlay
git checkout tags/v1.69
mkdir -p build
cd build
cmake ..
make
sudo make install

# Step 3: Enable Autologin in LightDM
echo "Step 3: Configuring LightDM autologin..."
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
sudo tee /etc/lightdm/lightdm.conf > /dev/null <<EOF
[Seat:*]
autologin-user=$CURRENT_USER
autologin-user-timeout=0
greeter-session=lightdm-gtk-greeter
user-session=xfce
EOF

# Step 4: Setup directories and cover image
echo "Step 4: Creating directories and cover image..."
convert -size 800x600 canvas:black /home/$CURRENT_USER/UxPlay/cover.jpg

# Step 5: Setup startup script
echo "Step 5: Setting up startup script..."
mkdir -p /home/$CURRENT_USER/.config/autostart
sudo tee /home/$CURRENT_USER/.config/autostart/startup.desktop > /dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Startup Script
Exec=/home/$CURRENT_USER/UxPlay/startup.sh
X-GNOME-Autostart-enabled=true
EOF

# Check if startup.sh exists in current directory
cd /home/$CURRENT_USER/UxPlay/
if [ ! -f "./startup.sh" ]; then
    echo "Error: startup.sh not found in current directory"
    echo "Please download startup.sh from the repository first"
    exit 1
fi

# Replace USER_PLACEHOLDER with actual username in startup.sh
sed -i "s/USER_PLACEHOLDER/$CURRENT_USER/g" /home/$CURRENT_USER/UxPlay/startup.sh

# Make startup script executable
chmod +x /home/$CURRENT_USER/UxPlay/startup.sh

echo "=== Bootstrap Complete ==="
