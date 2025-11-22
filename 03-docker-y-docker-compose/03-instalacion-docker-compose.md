# Instalación de Docker y Docker Compose

## Introducción

En este documento aprenderás a instalar Docker Engine y Docker Compose en tu servidor Ubuntu. Vamos paso a paso, explicando cada comando y por qué es necesario.

## Requisitos previos

Antes de comenzar, asegúrate de tener:

- Ubuntu Server 20.04 LTS o superior
- Acceso SSH a tu servidor
- Permisos de administrador (sudo)
- Conexión a Internet

**Verifica tu versión de Ubuntu:**

```bash
lsb_release -a
```

## Arquitectura del sistema

Docker es compatible con diferentes arquitecturas. Verifica la tuya:

```bash
uname -m
```

Resultado esperado:
- `x86_64` o `amd64` - Arquitectura de 64 bits (la más común)
- `aarch64` o `arm64` - ARM de 64 bits (Raspberry Pi 4, servidores ARM)

## Método 1: Instalación Recomendada (Repository Oficial)

Este es el método recomendado por Docker y el que usaremos.

### Paso 1: Actualizar el sistema

Primero actualizamos la lista de paquetes:

```bash
sudo apt update
```

### Paso 2: Instalar dependencias necesarias

Instalamos paquetes que permiten a `apt` usar repositorios sobre HTTPS:

```bash
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

**¿Qué hace cada paquete?**
- `ca-certificates`: Certificados de autoridad para verificar conexiones HTTPS
- `curl`: Para descargar archivos desde la web
- `gnupg`: Para verificar firmas de paquetes
- `lsb-release`: Para identificar tu distribución de Linux

### Paso 3: Agregar la clave GPG oficial de Docker

Las claves GPG verifican que los paquetes descargados son legítimos:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

**Explicación:**
1. Creamos el directorio para guardar claves
2. Descargamos la clave GPG de Docker
3. La convertimos a formato binario
4. Le damos permisos de lectura

### Paso 4: Configurar el repositorio de Docker

Agregamos el repositorio oficial de Docker a nuestras fuentes:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**¿Qué hace esto?**
- `$(dpkg --print-architecture)`: Detecta tu arquitectura automáticamente
- `$(lsb_release -cs)`: Detecta tu versión de Ubuntu (jammy, focal, etc.)
- `stable`: Usa la versión estable de Docker

### Paso 5: Actualizar el índice de paquetes

Actualizamos para incluir los paquetes del nuevo repositorio:

```bash
sudo apt update
```

### Paso 6: Instalar Docker Engine

Instalamos Docker Engine, CLI y Compose:

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Componentes instalados:**
- `docker-ce`: Docker Engine (el motor principal)
- `docker-ce-cli`: Interfaz de línea de comandos
- `containerd.io`: Runtime de contenedores
- `docker-buildx-plugin`: Constructor avanzado de imágenes
- `docker-compose-plugin`: Docker Compose V2

### Paso 7: Verificar la instalación

Comprueba que Docker se instaló correctamente:

```bash
# Ver versión de Docker
docker --version

# Ver versión de Docker Compose
docker compose version

# Ver información detallada del sistema
sudo docker info
```

**Resultado esperado:**

```
Docker version 24.0.x, build xxxxxx
Docker Compose version v2.x.x
```

### Paso 8: Probar Docker

Ejecuta el contenedor de prueba:

```bash
sudo docker run hello-world
```

Si ves un mensaje de "Hello from Docker!", ¡la instalación fue exitosa! 🎉

**¿Qué hace este comando?**
1. Busca la imagen `hello-world` localmente
2. Si no existe, la descarga de Docker Hub
3. Crea un contenedor con esa imagen
4. Ejecuta el contenedor
5. Muestra un mensaje de bienvenida

## Configuración post-instalación

### 1. Permitir usar Docker sin sudo

Por defecto, necesitas `sudo` para cada comando de Docker. Vamos a cambiarlo:

```bash
# Crear el grupo docker (si no existe)
sudo groupadd docker

# Agregar tu usuario al grupo docker
sudo usermod -aG docker $USER

# Activar los cambios en el grupo
newgrp docker
```

**⚠️ Importante**: Después de esto, cierra sesión y vuelve a conectarte para que los cambios surtan efecto.

**Verificar que funciona sin sudo:**

```bash
# Este comando ya no debería necesitar sudo
docker run hello-world
```

**Nota de seguridad**: El grupo `docker` otorga privilegios equivalentes a root. Solo agrega usuarios de confianza.

### 2. Configurar Docker para iniciar al arranque

Docker debe iniciarse automáticamente cuando el servidor se reinicie:

```bash
# Habilitar el servicio
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Verificar el estado
sudo systemctl status docker
```

**Resultado esperado:**
```
● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; enabled)
   Active: active (running) since...
```

### 3. Configurar límites de recursos (opcional)

Puedes limitar los recursos que Docker puede usar. Edita el archivo de configuración:

```bash
sudo nano /etc/docker/daemon.json
```

Ejemplo de configuración:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  }
}
```

**Explicación:**
- `log-driver`: Formato de logs
- `max-size`: Tamaño máximo de cada archivo de log (10 MB)
- `max-file`: Número máximo de archivos de log (3)
- `nofile`: Límite de archivos abiertos

Después de modificar, reinicia Docker:

```bash
sudo systemctl restart docker
```

## Método 2: Script de instalación rápida (Alternativo)

Docker ofrece un script de instalación automática. **Úsalo solo en entornos de desarrollo o prueba**, no en producción.

```bash
# Descargar y ejecutar el script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Limpiar
rm get-docker.sh
```

**⚠️ Advertencia**: Este método es más rápido pero menos controlable. Para producción usa el Método 1.

## Actualizar Docker

Para actualizar a la última versión:

```bash
# Actualizar lista de paquetes
sudo apt update

# Actualizar Docker
sudo apt upgrade docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verificar la nueva versión
docker --version
```

## Desinstalar Docker (si es necesario)

Si necesitas desinstalar Docker completamente:

```bash
# Desinstalar paquetes de Docker
sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Eliminar imágenes, contenedores y volúmenes
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Eliminar el grupo docker
sudo groupdel docker
```

## Configuración específica para Ubuntu Server

### 1. Configurar firewall (UFW)

Si usas UFW (firewall de Ubuntu), permite el tráfico de Docker:

```bash
# Permitir tráfico en el puerto de Docker (2375)
sudo ufw allow 2375/tcp

# Si usas Docker Swarm
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

# Recargar firewall
sudo ufw reload
```

### 2. Configurar red de Docker

Docker crea su propia red. Verifica que no haya conflictos:

```bash
# Ver redes existentes
docker network ls

# Ver configuración de red por defecto
docker network inspect bridge
```

Si hay conflictos con tu red local, puedes cambiar el rango de IPs:

```bash
sudo nano /etc/docker/daemon.json
```

Agregar:

```json
{
  "bip": "192.168.250.1/24",
  "default-address-pools": [
    {
      "base": "192.168.250.0/16",
      "size": 24
    }
  ]
}
```

Reiniciar Docker:

```bash
sudo systemctl restart docker
```

## Verificación completa de la instalación

Ejecuta esta serie de comandos para verificar todo:

```bash
# 1. Versión de Docker
docker --version

# 2. Versión de Docker Compose
docker compose version

# 3. Información del sistema
docker info

# 4. Probar ejecución básica
docker run --rm hello-world

# 5. Probar construcción de imagen
cat << 'EOF' > Dockerfile
FROM alpine:latest
CMD echo "Docker funciona correctamente"
EOF

docker build -t test-image .
docker run --rm test-image

# 6. Limpiar
rm Dockerfile
docker rmi test-image

# 7. Probar Docker Compose
cat << 'EOF' > docker-compose.yml
version: '3.8'
services:
  test:
    image: alpine:latest
    command: echo "Docker Compose funciona"
EOF

docker compose up
docker compose down

# 8. Limpiar
rm docker-compose.yml
```

Si todos estos comandos funcionan, ¡tu instalación está perfecta! ✅

## Solución de problemas comunes

### Problema: "Cannot connect to the Docker daemon"

**Causa**: El servicio Docker no está corriendo.

**Solución**:

```bash
# Iniciar el servicio
sudo systemctl start docker

# Verificar estado
sudo systemctl status docker
```

### Problema: "Permission denied" al ejecutar docker

**Causa**: Tu usuario no está en el grupo `docker`.

**Solución**:

```bash
# Agregar usuario al grupo
sudo usermod -aG docker $USER

# Cerrar sesión y volver a entrar
exit
```

### Problema: Error "address already in use"

**Causa**: Otro servicio usa el puerto que Docker necesita.

**Solución**:

```bash
# Ver qué proceso usa el puerto (ejemplo: puerto 80)
sudo lsof -i :80

# Detener el proceso o cambiar el puerto en docker-compose.yml
```

### Problema: Espacio en disco insuficiente

**Causa**: Acumulación de imágenes, contenedores y volúmenes no usados.

**Solución**:

```bash
# Limpiar todo lo que no se usa
docker system prune -a --volumes

# Ver uso de espacio
docker system df
```

### Problema: Docker muy lento

**Soluciones**:

1. **Aumentar memoria disponible** (editar `/etc/docker/daemon.json`):

```json
{
  "default-runtime": "runc",
  "storage-driver": "overlay2"
}
```

2. **Limpiar logs acumulados**:

```bash
# Encontrar y limpiar logs grandes
sudo find /var/lib/docker/containers/ -name "*-json.log" -exec truncate -s 0 {} \;
```

## Comandos útiles de diagnóstico

```bash
# Estado del servicio Docker
sudo systemctl status docker

# Ver logs del servicio Docker
sudo journalctl -u docker -f

# Ver eventos en tiempo real
docker events

# Estadísticas de contenedores en ejecución
docker stats

# Espacio usado por Docker
docker system df -v

# Información detallada del sistema
docker info

# Verificar conectividad a Docker Hub
docker pull alpine:latest
```

## Configuración de seguridad adicional

### 1. Limitar acceso al socket de Docker

El socket de Docker es poderoso. Protégelo:

```bash
# Ver permisos actuales
ls -la /var/run/docker.sock

# Cambiar permisos (solo root y grupo docker)
sudo chmod 660 /var/run/docker.sock
```

### 2. Configurar AppArmor o SELinux

Ubuntu usa AppArmor por defecto para seguridad adicional:

```bash
# Verificar que AppArmor está activo
sudo aa-status

# Ver perfil de Docker
sudo aa-status | grep docker
```

### 3. Habilitar el modo rootless (avanzado)

Docker puede ejecutarse sin privilegios de root:

```bash
# Instalar dependencias
sudo apt install -y uidmap

# Ejecutar script de instalación rootless
dockerd-rootless-setuptool.sh install

# Configurar variables de entorno
export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
```

**Nota**: El modo rootless tiene limitaciones. Documéntate bien antes de usarlo en producción.

## Recursos y ubicaciones importantes

```
Archivos de configuración:
/etc/docker/daemon.json          - Configuración de Docker
/etc/docker/                     - Directorio de configuración

Datos de Docker:
/var/lib/docker/                 - Imágenes, contenedores, volúmenes
/var/lib/docker/containers/      - Datos de contenedores
/var/lib/docker/volumes/         - Volúmenes persistentes

Logs:
/var/log/docker.log              - Logs del daemon (si está configurado)
/var/lib/docker/containers/[ID]/ - Logs de cada contenedor

Socket:
/var/run/docker.sock             - Socket Unix para comunicación
```

## Lista de verificación final

Antes de continuar, asegúrate de que:

- ✅ Docker Engine está instalado y corriendo
- ✅ Docker Compose está instalado (versión 2.x)
- ✅ Puedes ejecutar `docker` sin `sudo`
- ✅ El servicio Docker se inicia al arranque
- ✅ `docker run hello-world` funciona correctamente
- ✅ `docker compose version` muestra la versión instalada
- ✅ El firewall permite el tráfico necesario (si aplica)

## Próximos pasos

¡Felicitaciones! Docker y Docker Compose están listos para usar. Ahora puedes continuar con:

1. ✅ ¿Qué es Docker?
2. ✅ ¿Qué es Docker Compose?
3. ✅ **Instalación** (este documento)
4. ⏭️ **Comandos básicos** - Aprender a usar Docker en el día a día
5. ⏭️ **Mejores prácticas** - Optimizar y asegurar tus contenedores

---

**💡 Consejo**: Practica ejecutando algunos contenedores de prueba antes de pasar a aplicaciones complejas. Familiarízate con los comandos básicos.