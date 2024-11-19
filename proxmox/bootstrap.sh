#!/bin/bash

set -e

echo "=== Proxmox VE Post-Installation Bootstrap ==="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root"
   exit 1
fi

# Check if running on Proxmox
if ! command -v pveversion &> /dev/null; then
    echo "ERROR: This script is designed for Proxmox VE systems only"
    exit 1
fi

echo "Proxmox VE version: $(pveversion --verbose | head -1)"

# 1. Configure No-Subscription Repositories
echo "Configuring no-subscription repositories..."

# Backup original sources
cp /etc/apt/sources.list /etc/apt/sources.list.backup 2>/dev/null || true
cp /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.backup 2>/dev/null || true

# Disable enterprise repository
echo "# deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise" > /etc/apt/sources.list.d/pve-enterprise.list

# Add no-subscription repository
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

# Disable Ceph enterprise repository if it exists
if [ -f /etc/apt/sources.list.d/ceph.list ]; then
    cp /etc/apt/sources.list.d/ceph.list /etc/apt/sources.list.d/ceph.list.backup
    sed -i 's/^deb https:\/\/enterprise.proxmox.com\/debian\/ceph-quincy bookworm enterprise/#&/' /etc/apt/sources.list.d/ceph.list
    echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" >> /etc/apt/sources.list.d/ceph.list
fi

# 2. Update system
echo "Updating package lists and upgrading system..."
apt update && apt upgrade -y

# 3. Disable subscription notice
echo "Disabling subscription notice in web interface..."

# Backup original file
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.backup

# Disable subscription notice
sed -i "s/data.status.toLowerCase() !== 'active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# 4. Remove local-lvm and extend root partition
echo "Removing LVM data volume..."

# Check if data volume exists
if lvs | grep -q "data"; then
    lvremove -f /dev/pve/data
    echo "Extending root volume..."
    lvextend -l +100%FREE /dev/pve/root
    resize2fs /dev/mapper/pve-root
    REBOOT_REQUIRED=true
else
    echo "No data volume found to remove"
fi

# 5. Restart Proxmox services
echo "Restarting Proxmox services..."
systemctl restart pveproxy
systemctl restart pvedaemon

# Final summary
echo
echo "=== Bootstrap completed successfully! ==="

if [ "$REBOOT_REQUIRED" = true ]; then
    echo "Rebooting system..."
    reboot
fi