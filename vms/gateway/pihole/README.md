# Pi-hole

Pi-hole provides network-wide DNS filtering, ad blocking, and local DNS resolution for the home lab network.

## Quick Start
1. Create project directories
    ```
    mkdir pihole
    cd pihole
    ```
2. Download required files
    ```
    wget -O docker-compose.yml https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/pihole/docker-compose.yml
    wget -O .env https://raw.githubusercontent.com/yourusername/tomasz-umanski/home-server/main/vms/gateway/pihole/example.env
    ```
3. Adjust downloaded .env file
4. Deploy service
    ```
    docker-compose up -d
    ```
5. Configure Pi-hole DNS Records
6. Access Service
   - Pi-hole Admin: https://[GATEWAY-IP]:8080/admin
7. Configure router: Set primary DNS to the [GATEWAY-IP]
