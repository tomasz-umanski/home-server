# Proxmox installation guide

## Pre-Installation Preparation
### BIOS Settings
1. Boot into BIOS
2. Enable virtualization features:
   - Intel VT-x: Enabled 
   - Intel VT-d: Enabled 
3. Set boot priority to USB/UEFI for installation media 
4. Disable Secure Boot if enabled

### Installation Media
1. Download latest Proxmox VE ISO from [Proxmox Virtual Environment](https://www.proxmox.com/en/downloads/proxmox-virtual-environment)
2. Create bootable USB drive

## **Installation Process**
- Hostname: pve.homelab.local

## **Post-Installation Configuration**
### 1. Initial Access
1. Access web interface: https://[PROXMOX-IP]:8006/
2. Login with root and password set during installation
3. Remove local-lvm storage from web interface first: Datacenter > Storage > local-lvm > Remove
4. Run the bootstrap script
```
wget -O bootstrap.sh https://raw.githubusercontent.com/yourusername/tomasz-umanski/home-server/main/proxmox/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```
