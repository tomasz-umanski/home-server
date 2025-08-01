# Immich

Self-hosted photo and video management solution

## Quick Start

1. Create project directories
    ```bash
    mkdir ./immich-app
    cd ./immich-app
    ```
2. Download required files
    ```bash
    sudo wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
    sudo wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
    ```
3. Adjust downloaded .env file
4. Deploy service
    ```bash
    sudo docker compose up -d
    ```
5. Access Service
    - Proxy Manager Admin: https://[MEDIA-IP]:2283
    - Import settings from immich-config.json file
6. Configure reverse proxy using proxy-manager

In case of any problems go to [Immich addocs](https://immich.app/docs/install/docker-compose/)