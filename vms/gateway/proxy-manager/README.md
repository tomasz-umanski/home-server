# Nginx Proxy Manager

Nginx Proxy Manager provides a web-based interface for managing reverse proxy configurations with automatic SSL certificate generation and management.

## Quick Start
1. Create project directories
    ```
    mkdir proxy-manager
    cd proxy-manager
    ```
2. Download required files
    ```
    wget -O docker-compose.yml https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/proxy-manager/docker-compose.yml
    wget -O .env https://raw.githubusercontent.com/yourusername/tomasz-umanski/home-server/main/vms/gateway/proxy-manager/example.env
    ```
3. Adjust downloaded .env file
4. Deploy service
    ```
    docker-compose up -d
    ```
5. Access Service
    - Proxy Manager Admin: https://[GATEWAY-IP]:81/admin

## SSL Configuration
For each proxy host:
1. Go to SSL tab 
2. Select "Request a new SSL Certificate"
3. Check "Force SSL"
4. Check "HTTP/2 Support"
   - For external domains, use Let's Encrypt 
   - For local domains, use self-signed certificates
