Instalación de docker. Utilizar el script de recursos o ejecutar los siguientes comandos

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

¿Qué hace?
curl -fsSL https://get.docker.com -o get-docker.sh --> Descarga el script oficial de instalación de Docker desde su web y lo guarda en un archivo llamado get-docker.sh.

sudo sh get-docker.sh --> Ejecuta el script de instalación de Docker. Este script:
                                Detecta tu sistema operativo
                                Añade los repositorios de Docker
                                Instala Docker Engine
                                Configura el servicio para que arranque automáticamente

rm get-docker.sh --> Para borra el script de instalación porque ya no lo necesitamos.
¿Por qué borrarlo?
Limpieza. Ya hizo su trabajo, no hace falta mantenerlo.

sudo usermod -aG docker $USER --> Añade tu usuario al grupo "docker". ¿Por qué es necesario?
                                    Por defecto, solo root puede ejecutar comandos Docker. Si te añades al grupo "docker", puedes ejecutar docker sin sudo.
'''
⚠️ IMPORTANTE:
Este cambio solo se aplica después de cerrar sesión y volver a entrar. Por eso el script te lo recuerda al final.
'''

sudo apt install -y docker-compose-plugin --> Instalar Docker Compose

¿Por qué necesitamos Docker Compose?
Para gestionar fácilmente Home Assistant, Nextcloud, n8n, etc., todos juntos con un solo archivo docker-compose.yml.

Link a QuickStart 

