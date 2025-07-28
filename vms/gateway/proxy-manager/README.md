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
    sudo wget -O docker-compose.yml https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/proxy-manager/docker-compose.yml
    sudo wget -O .env https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/proxy-manager/example.env
    ```
3. Adjust downloaded .env file
4. Deploy service
    ```
    sudo docker compose up -d
    ```
5. Access Service
    - Proxy Manager Admin: https://[GATEWAY-IP]:81/login
    - Default credentials are
      - Email:    admin@example.com 
      - Password: changeme

## Root SSL Configuration
1. Create local CA
    ```
    mkdir -p ~/local-ca/{certs,private,csr}
    cd ~/local-ca
   
    openssl genrsa -out private/rootCA.key 4096
   
    openssl req -x509 -new -nodes -key private/rootCA.key -sha256 -days 3650 \
      -out certs/rootCA.pem \
      -subj "/C=PL/ST=Local/L=Lab/O=HomeLab/OU=CA/CN=HomeLab Root CA" 
    ```
2. Install root CA on local device.

## Host Configuration
1. Create cert for service
   ```
   openssl genrsa -out private/{service}.lab.lan.key 2048
   
   openssl req -new -key private/{service}.lab.lan.key -out csr/{service}.lab.lan.csr \
   -subj "/C=PL/ST=Local/L=Lab/O=HomeLab/CN={service}.lab.lan"
   
   openssl x509 -req -in csr/{service}.lab.lan.csr -CA certs/rootCA.pem -CAkey private/rootCA.key \
   -CAcreateserial -out certs/{service}.lab.lan.crt -days 825 -sha256
   ```
2. Install certs in NPM 
   - Go to "SSL Certificates"
   - Click “Add SSL Certificate” → “Custom” 
   - Provide:
      - Name: {service}.lab.lan 
      - Certificate File: {service}.lab.lan.crt 
      - Key File: {service}.lab.lan.key
   - Save
3. Add new Host
   - Go to "Proxy Hosts"
   - Click “Add Proxy Host”
   - Provide required details
     - Domain Name: {service}.lab.lan 
     - Scheme: http or https (depending on your service)
     - Forward Hostname/IP: Internal IP of the service (e.g. 192.168.0.142)
     - Forward Port: e.g. 8006 
     - Select: “Block Common Exploits”
   - Go to "SSL Certificate"
     - Select proper cert
     - Check "Force SSL" and "HTTP/2 Support"
   - Save
4. Configure local DNS on Pi-hole
   - Open Pi-hole admin panel
   - Navigate to Local DNS → DNS Records 
   - Add a new entry:
     - Domain: {service}.lab.lan 
     - IP Address: IP of your NPM host (e.g. 192.168.0.245)
   - Save the record
