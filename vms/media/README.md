# Media VM

The Media VM serves as the network services hub, providing photos and files management platforms

## Services
- Immich: Network-wide ad blocking and DNS filtering 

## VM Specifications
- CPU: 2 cores 
- RAM: 4GB 
- Disk: 128GB 
- OS: Debian 12.10.0
- Hostname: media.homelab.local

## Quick Start
- Deploy VM using proxmox
- Enable start at boot option
- Install sudo and add user to sudoers group
  ```
  apt update
  apt install sudo
  usermod -aG sudo {user}
  ```
- Install docker [Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)
- Deploy services using provided instructions 
