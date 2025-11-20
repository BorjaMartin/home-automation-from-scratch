#!/bin/bash

echo "================================================"
echo "  CONFIGURACIÓN AUTOMÁTICA SERVIDOR CASERO"
echo "  Ubuntu Server 24.04 LTS"
echo "================================================"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}[1/8] Actualizando sistema...${NC}"
sudo apt update
sudo apt upgrade -y

echo -e "${GREEN}[2/8] Instalando herramientas básicas...${NC}"
sudo apt install -y curl wget git nano htop net-tools ufw

echo -e "${GREEN}[3/8] Instalando Docker...${NC}"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

echo -e "${GREEN}[4/8] Configurando Docker...${NC}"
sudo usermod -aG docker $USER
sudo apt install -y docker-compose-plugin

echo -e "${GREEN}[5/8] Configurando firewall UFW...${NC}"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 8123/tcp    # Home Assistant
sudo ufw allow 5678/tcp    # n8n
sudo ufw allow 8080/tcp    # Nextcloud
sudo ufw allow 9000/tcp    # Portainer
sudo ufw allow 8888/tcp    # Dozzle
sudo ufw allow 61208/tcp   # Glances
sudo ufw allow 51820/udp   # WireGuard
sudo ufw --force enable

echo -e "${GREEN}[6/8] Creando estructura de carpetas...${NC}"
mkdir -p ~/servidor/{home-assistant,n8n,nextcloud,wireguard,nginx-proxy-manager,portainer,databases/mariadb,photoprism,jellyfin,samba,filebrowser,syncthing,duplicati,mosquitto/{config,data,log},redis}

echo -e "${GREEN}[7/8] Configurando Mosquitto...${NC}"
cat > ~/servidor/mosquitto/config/mosquitto.conf << EOF
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
EOF

echo -e "${GREEN}[8/8] Configuración completada!${NC}"
echo ""
echo "================================================"
echo -e "${YELLOW}IMPORTANTE: Cierra sesión y vuelve a entrar${NC}"
echo "Ejecuta: exit"
echo "Y vuelve a hacer login"
echo "================================================"