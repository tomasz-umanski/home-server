# Gateway VM

The Gateway VM serves as the network services hub, providing DNS filtering and reverse proxy services for the home lab.

## Services
- Pi-hole: Network-wide ad blocking and DNS filtering 
- Nginx Proxy Manager: Reverse proxy with SSL termination 

## VM Specifications
- CPU: 1 cores 
- RAM: 1GB 
- Disk: 8GB 
- OS: Debian 12.10.0
- Hostname: gateway.homelab.local

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
