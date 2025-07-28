# Pi-hole

This setup deploys Pi-hole for network-wide ad blocking, backed by Unbound for secure, recursive DNS resolution.

## Quick Start
1. Create project directories
    ```
    mkdir pihole-unbound
    cd pihole-unbound
    mkdir unbound
    ```
2. Download required files
    ```
    sudo wget -O docker-compose.yml https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/pihole-unbound/docker-compose.yml
    sudo wget -O .env https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/pihole-unbound/example.env
    sudo wget -O unbound/unbound.conf https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/pihole-unbound/unbound.conf
    ```
3. Adjust downloaded .env file
4. Deploy service
    ```
    sudo docker compose up -d
    ```
5. Configure Pi-hole password
   ```
   sudo docker exec -it pihole pihole setpassword
   ```
6. Configure Pi-hole DNS Records
   - Access Pi-hole Admin: https://[GATEWAY-IP]:8080/admin 
   - Go to Settings → DNS
   - Uncheck all upstream DNS servers
   - Add custom DNS server: 172.23.0.20#53 (Unbound container)
   - Enable "Use DNSSEC"
   - Configure blocklists in Settings → Blocklists
   - Adjust Interface setting to respond not only to local network
7. Configure router: Set primary DNS to the [GATEWAY-IP]
8. Configure proxmox dns: Set node DNS to the [GATEWAY-IP]
