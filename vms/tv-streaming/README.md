# TV Streaming VM

The TV Streaming VM serves as the entertainment services hub.

## Services

- UxPlay: AirPlay Unix mirroring server that acts like an AppleTV for screen-mirroring
- iSponsorBlockTV: SponsorBlock client for all YouTube TV clients that skips sponsor segments in YouTube

## VM Specifications

- CPU: 1 cores
- RAM: 1GB
- Disk: 8GB
- OS: Debian 12.10.0
- Hostname: tv-streaming.lab.lan

## Quick Start

- Deploy VM using proxmox
- Setup static IP Address
- Enable start at boot option
- Install sudo and add user to sudoers group
  ```bash
  apt update
  apt install sudo
  usermod -aG sudo {user}
  ```
- Deploy services using provided instructions 