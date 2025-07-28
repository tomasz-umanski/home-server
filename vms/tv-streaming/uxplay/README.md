# Uxplay

AirPlay Unix mirroring server that acts like an AppleTV for screen-mirroring (with audio) of iOS/iPadOS/macOS clients (
iPhones, iPads, MacBooks). Allows you to turn your Linux machine into a second display for your Mac and enables wireless
screen sharing from Apple devices to your TV or display connected to this VM.

## Proxmox Resource Mapping Configuration

### GPU Passthrough

1. [Verify_IOMMU_is_enabled](https://pve.proxmox.com/wiki/PCI_Passthrough#Verify_IOMMU_is_enabled)
2. Enable IOMMU in Proxmox host:
   ```bash
   # Edit GRUB configuration
   nano /etc/default/grub
   
   # Add to GRUB_CMDLINE_LINUX_DEFAULT:
   # For Intel: intel_iommu=on
   
   # Update GRUB and reboot
   update-grub
   reboot
   ```
3. Add GPU to VM
    - In Proxmox web interface:
    - Go to: Datacenter > Resource Mappings > PCI Devices > Add
    - Provide name: gpu
    - Select GPU device
    - Click Create
    - Go to: VM > Hardware > Add > PCI Device
    - Select created gpu Mapped Device
    - Enable: Primary GPU
    - Disable: ROM-Bar
    - Click Add
    - Reboot vm from Proxmox web interface

### Audio Passthrough

1. Add audio to VM
    - In Proxmox web interface:
    - Go to: Datacenter > Resource Mappings > PCI Devices > Add
    - Provide name: audio
    - Select audio device
    - Click Create
    - Go to: VM > Hardware > Add > PCI Device
    - Select created audio Mapped Device
    - Disable: ROM-Bar
    - Click Add
    - Reboot vm from Proxmox web interface

## Quick Start

1. Create project directories
   ```bash
   mkdir UxPlay
   cd UxPlay
   ```
2. Download required files
   ```bash
   sudo wget -O bootstrap.sh https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/tv-streaming/uxplay/bootstrap.sh
   sudo wget -O startup.sh https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/tv-streaming/uxplay/startup.sh
   sudo chmod +x bootstrap.sh startup.sh
   ```
3. Run automated bootstrap
   ```bash
   ./bootstrap.sh
   ```
4. Reboot system
   ```
   sudo reboot
   ```
