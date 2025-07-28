# Nginx Proxy Manager

Nginx Proxy Manager provides a web-based interface for managing reverse proxy configurations with automatic SSL
certificate generation and management.

## Quick Start

1. Create project directories
    ```bash
    mkdir proxy-manager
    cd proxy-manager
    ```
2. Download required files
    ```bash
    sudo wget -O docker-compose.yml https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/proxy-manager/docker-compose.yml
    sudo wget -O .env https://raw.githubusercontent.com/tomasz-umanski/home-server/main/vms/gateway/proxy-manager/example.env
    ```
3. Adjust downloaded .env file
4. Deploy service
    ```bash
    sudo docker compose up -d
    ```
5. Access Service
    - Proxy Manager Admin: https://[GATEWAY-IP]:81/login
    - Default credentials are
        - Email:    admin@example.com
        - Password: changeme

## Root SSL Configuration

1. Create Local Certificate Authority (CA)
    ```bash
    mkdir -p ~/local-ca/{certs,private,csr}
    cd ~/local-ca
    
    # Generate root private key
    openssl genrsa -out private/rootCA.key 4096
    
    # Create root certificate (valid for 10 years)
    openssl req -x509 -new -nodes -key private/rootCA.key -sha256 -days 3650 \
      -out certs/rootCA.pem \
      -subj "/C=PL/ST=Local/L=Lab/O=HomeLab/OU=CA/CN=HomeLab Root CA"
    ```
2. Install Root CA on Local Device
    - open Keychain Access, drag rootCA.pem into System, double-click → expand Trust → set Always Trust.

## Host SSL Certificate Configuration

1. Assign Service variable
    ```bash
    SERVICE="pve"  # Change this to your actual service name
    ```
2. Generate required files
    ```bash
    # Generate private key
    openssl genrsa -out private/${SERVICE}.lab.lan.key 2048
    
    # Create a Certificate Signing Request (CSR)
    openssl req -new -key private/${SERVICE}.lab.lan.key \
    -out csr/${SERVICE}.lab.lan.csr \
    -subj "/C=PL/ST=Local/L=Lab/O=HomeLab/CN=${SERVICE}.lab.lan"
    
    # Create a SAN configuration file
    cat > ~/local-ca/san-${SERVICE}.ext << EOF
    authorityKeyIdentifier=keyid,issuer
    basicConstraints=CA:FALSE
    keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
    subjectAltName = @alt_names
    
    [alt_names]
    DNS.1 = ${SERVICE}.lab.lan
    EOF
    
    # Sign the certificate with SAN extension
    openssl x509 -req -in csr/${SERVICE}.lab.lan.csr \
    -CA certs/rootCA.pem -CAkey private/rootCA.key -CAcreateserial \
    -out certs/${SERVICE}.lab.lan.crt -days 825 -sha256 \
    -extfile san-${SERVICE}.ext
    
    # Create a fullchain certificate
    cat certs/${SERVICE}.lab.lan.crt certs/rootCA.pem > certs/fullchain.${SERVICE}.lab.lan.crt
    ```

## Nginx Proxy Manager Setup

1. Install Certificates in Nginx Proxy Manager
    - Go to "SSL Certificates"
    - Click “Add SSL Certificate” → “Custom”
    - Provide:
        - Name: ${SERVICE}.lab.lan
        - Certificate File: contents of certs/fullchain.${SERVICE}.lab.lan.crt
        - Key File: contents of private/${SERVICE}.lab.lan.key
    - Save
2. Add New Host in Nginx Proxy Manager
    - Go to "Proxy Hosts"
    - Click “Add Proxy Host”
    - Provide required details
        - Domain Name: ${SERVICE}.lab.lan
        - Scheme: http or https (depending on service)
        - Forward Hostname/IP: Internal IP of the service (e.g. 192.168.0.142)
        - Forward Port: e.g. 8006
        - Select: “Block Common Exploits” and "Websockets Support" if applicable
    - Go to "SSL Certificate"
        - SSL Certificate: select ${SERVICE}.lab.lan from dropdown
        - Check "Force SSL" and "HTTP/2 Support"
    - Save

## Configure Local DNS in Pi-hole

1. Configure local DNS on Pi-hole
    - Open Pi-hole admin panel
    - Navigate to Local DNS → DNS Records
    - Add a new entry:
        - Domain: ${SERVICE}.lab.lan
        - IP Address: IP of your NPM host (e.g. 192.168.0.245)
    - Save the record
