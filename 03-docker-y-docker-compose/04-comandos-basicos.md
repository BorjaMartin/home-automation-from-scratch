# Comandos Básicos de Docker y Docker Compose

## Introducción

Este documento es tu referencia rápida de comandos esenciales de Docker y Docker Compose. Cada comando está explicado con ejemplos prácticos y casos de uso reales.

## Estructura del documento

- **Comandos Docker CLI**: Gestión directa de contenedores
- **Comandos Docker Compose**: Gestión de aplicaciones multi-contenedor
- **Comandos de gestión de imágenes**
- **Comandos de gestión de volúmenes y redes**
- **Comandos de diagnóstico y limpieza**

---

## PARTE 1: Comandos de Docker CLI

### Gestión de contenedores

#### `docker run` - Crear y ejecutar un contenedor

El comando más importante. Crea y ejecuta un contenedor a partir de una imagen.

**Sintaxis básica:**
```bash
docker run [OPCIONES] IMAGEN [COMANDO] [ARGS]
```

**Ejemplos:**

```bash
# Ejecutar contenedor simple
docker run ubuntu:22.04 echo "Hola Docker"

# Ejecutar en modo interactivo
docker run -it ubuntu:22.04 bash

# Ejecutar en segundo plano (detached)
docker run -d nginx:alpine

# Con nombre personalizado
docker run --name mi_servidor -d nginx:alpine

# Mapear puertos (host:contenedor)
docker run -p 8080:80 -d nginx:alpine

# Con variables de entorno
docker run -e MYSQL_ROOT_PASSWORD=secret -d mysql:8.0

# Montar volumen
docker run -v mi_volumen:/data -d alpine

# Montar carpeta local (bind mount)
docker run -v /ruta/local:/ruta/contenedor -d nginx

# Eliminar automáticamente al terminar
docker run --rm alpine echo "Me eliminaré al terminar"

# Limitar recursos
docker run --memory="512m" --cpus="1.0" -d nginx
```

**Opciones comunes:**

| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `-d` | Ejecutar en segundo plano (detached) | `docker run -d nginx` |
| `-it` | Modo interactivo con terminal | `docker run -it ubuntu bash` |
| `-p` | Mapear puerto | `docker run -p 80:80 nginx` |
| `--name` | Dar nombre al contenedor | `docker run --name web nginx` |
| `-e` | Variable de entorno | `docker run -e KEY=value app` |
| `-v` | Montar volumen | `docker run -v data:/app nginx` |
| `--rm` | Eliminar al terminar | `docker run --rm alpine ls` |
| `--network` | Conectar a red específica | `docker run --network mi_red app` |
| `--restart` | Política de reinicio | `docker run --restart=always nginx` |

**Políticas de reinicio:**
- `no`: No reiniciar (por defecto)
- `on-failure`: Reiniciar si falla
- `always`: Siempre reiniciar
- `unless-stopped`: Reiniciar excepto si se detuvo manualmente

#### `docker ps` - Listar contenedores

```bash
# Listar contenedores en ejecución
docker ps

# Listar todos los contenedores (incluidos detenidos)
docker ps -a

# Mostrar solo IDs
docker ps -q

# Formato personalizado
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Filtrar por estado
docker ps --filter "status=running"
docker ps --filter "status=exited"

# Últimos N contenedores creados
docker ps -n 5
```

**Salida típica:**
```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
a1b2c3d4e5f6   nginx:alpine   "/docker-entrypoint.…"   10 minutes ago   Up 10 minutes   0.0.0.0:80->80/tcp    mi_servidor
```

#### `docker start/stop/restart` - Controlar contenedores

```bash
# Iniciar contenedor detenido
docker start mi_contenedor

# Iniciar varios contenedores
docker start contenedor1 contenedor2

# Detener contenedor (SIGTERM, luego SIGKILL después de 10s)
docker stop mi_contenedor

# Detener inmediatamente (SIGKILL)
docker kill mi_contenedor

# Reiniciar contenedor
docker restart mi_contenedor

# Pausar contenedor (congela procesos)
docker pause mi_contenedor

# Reanudar contenedor pausado
docker unpause mi_contenedor
```

#### `docker exec` - Ejecutar comandos en contenedor activo

```bash
# Ejecutar comando simple
docker exec mi_contenedor ls /app

# Abrir shell interactivo
docker exec -it mi_contenedor bash

# Ejecutar como usuario específico
docker exec -u root mi_contenedor apt update

# Establecer variables de entorno
docker exec -e VAR=value mi_contenedor env

# Ver logs en tiempo real
docker exec mi_contenedor tail -f /var/log/app.log
```

**Diferencia con `docker run`:**
- `docker run`: Crea un NUEVO contenedor
- `docker exec`: Ejecuta en contenedor EXISTENTE

#### `docker logs` - Ver logs de contenedores

```bash
# Ver todos los logs
docker logs mi_contenedor

# Seguir logs en tiempo real (como tail -f)
docker logs -f mi_contenedor

# Últimas N líneas
docker logs --tail 100 mi_contenedor

# Logs desde una fecha/hora específica
docker logs --since 2024-01-01T00:00:00 mi_contenedor

# Logs desde hace X tiempo
docker logs --since 1h mi_contenedor  # última hora
docker logs --since 30m mi_contenedor  # últimos 30 minutos

# Añadir timestamps
docker logs -t mi_contenedor

# Combinar opciones
docker logs -f --tail 50 -t mi_contenedor
```

#### `docker rm` - Eliminar contenedores

```bash
# Eliminar contenedor detenido
docker rm mi_contenedor

# Forzar eliminación (aunque esté corriendo)
docker rm -f mi_contenedor

# Eliminar múltiples contenedores
docker rm contenedor1 contenedor2

# Eliminar todos los contenedores detenidos
docker rm $(docker ps -aq -f status=exited)

# Con Docker Compose
docker compose rm
```

#### `docker inspect` - Información detallada

```bash
# Información completa en JSON
docker inspect mi_contenedor

# Extraer información específica
docker inspect --format='{{.State.Status}}' mi_contenedor
docker inspect --format='{{.NetworkSettings.IPAddress}}' mi_contenedor

# Ver solo redes
docker inspect --format='{{json .NetworkSettings.Networks}}' mi_contenedor | jq

# Ver variables de entorno
docker inspect --format='{{.Config.Env}}' mi_contenedor
```

#### `docker stats` - Estadísticas de recursos

```bash
# Ver uso de recursos de todos los contenedores
docker stats

# Contenedor específico
docker stats mi_contenedor

# Sin streaming (una sola captura)
docker stats --no-stream

# Formato personalizado
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

---

## PARTE 2: Comandos de Docker Compose

### Gestión de servicios

#### `docker compose up` - Iniciar servicios

El comando principal de Docker Compose.

```bash
# Iniciar todos los servicios
docker compose up

# Iniciar en segundo plano (detached)
docker compose up -d

# Reconstruir imágenes antes de iniciar
docker compose up --build

# Iniciar servicios específicos
docker compose up -d nginx postgres

# Forzar recreación de contenedores
docker compose up -d --force-recreate

# No recrear servicios que ya existen
docker compose up -d --no-recreate

# Escalar servicios (múltiples instancias)
docker compose up -d --scale web=3

# Usar archivo compose alternativo
docker compose -f docker-compose.prod.yml up -d

# Combinar múltiples archivos
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d
```

**Flujo de `docker compose up`:**
1. Crea redes definidas (si no existen)
2. Crea volúmenes definidos (si no existen)
3. Construye imágenes (si se especifica `build`)
4. Crea y arranca contenedores
5. Respeta `depends_on` para orden de inicio

#### `docker compose down` - Detener y eliminar servicios

```bash
# Detener y eliminar contenedores y redes
docker compose down

# También eliminar volúmenes
docker compose down -v

# También eliminar imágenes
docker compose down --rmi all

# Eliminar solo imágenes locales (sin tag)
docker compose down --rmi local

# Tiempo de espera antes de forzar detención (default: 10s)
docker compose down -t 30
```

**⚠️ Importante**: `docker compose down -v` eliminará TODOS los datos en volúmenes. Úsalo con cuidado.

#### `docker compose start/stop/restart` - Control de servicios

```bash
# Iniciar servicios ya creados (no crea nuevos)
docker compose start

# Iniciar servicio específico
docker compose start web

# Detener servicios (no elimina contenedores)
docker compose stop

# Detener servicio específico
docker compose stop web

# Reiniciar todos los servicios
docker compose restart

# Reiniciar servicio específico
docker compose restart app
```

**Diferencia clave:**
- `stop`: Detiene pero mantiene configuración
- `down`: Detiene y elimina contenedores

#### `docker compose ps` - Estado de servicios

```bash
# Listar todos los servicios
docker compose ps

# Incluir servicios detenidos
docker compose ps -a

# Formato personalizado
docker compose ps --format json

# Ver solo IDs
docker compose ps -q

# Filtrar por servicio
docker compose ps web
```

#### `docker compose logs` - Ver logs

```bash
# Ver logs de todos los servicios
docker compose logs

# Seguir logs en tiempo real
docker compose logs -f

# Logs de servicio específico
docker compose logs web

# Últimas N líneas
docker compose logs --tail=100

# Desde hace X tiempo
docker compose logs --since 1h

# Combinar opciones
docker compose logs -f --tail=50 web

# Ver logs de múltiples servicios
docker compose logs -f web db
```

#### `docker compose exec` - Ejecutar comandos

```bash
# Abrir shell en servicio
docker compose exec web bash

# Ejecutar comando
docker compose exec db psql -U postgres

# Sin asignar TTY (útil en scripts)
docker compose exec -T web cat /app/config.txt

# Como usuario específico
docker compose exec -u root web apt update

# En contenedor específico de un servicio escalado
docker compose exec --index=2 web bash
```

#### `docker compose build` - Construir imágenes

```bash
# Construir todas las imágenes
docker compose build

# Construir sin cache
docker compose build --no-cache

# Construir servicio específico
docker compose build web

# Construir con argumentos
docker compose build --build-arg VERSION=1.0 web

# Construir en paralelo (más rápido)
docker compose build --parallel

# Pull de imágenes base primero
docker compose build --pull
```

#### `docker compose pull` - Descargar imágenes

```bash
# Descargar todas las imágenes
docker compose pull

# Servicio específico
docker compose pull web

# Ignorar errores de pull
docker compose pull --ignore-pull-failures

# Descargar en paralelo
docker compose pull --parallel
```

#### `docker compose config` - Validar configuración

```bash
# Ver configuración procesada
docker compose config

# Validar sin mostrar salida
docker compose config --quiet

# Resolver paths
docker compose config --resolve-image-digests

# Ver servicios definidos
docker compose config --services

# Ver volúmenes definidos
docker compose config --volumes

# Ver perfiles disponibles
docker compose config --profiles
```

Este comando es útil para debuggear problemas de configuración.

---

## PARTE 3: Gestión de imágenes

#### `docker images` - Listar imágenes

```bash
# Listar todas las imágenes
docker images

# Listar todas (incluye intermedias)
docker images -a

# Solo IDs
docker images -q

# Filtrar por nombre
docker images nginx

# Filtrar por dangling (sin tag)
docker images -f "dangling=true"

# Formato personalizado
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

#### `docker pull` - Descargar imágenes

```bash
# Descargar última versión
docker pull nginx

# Descargar versión específica
docker pull nginx:1.25-alpine

# Descargar de registro privado
docker pull registry.miempresa.com/mi-app:v1.0

# Descargar todas las tags de una imagen
docker pull --all-tags nginx

# Descargar para arquitectura específica
docker pull --platform linux/arm64 nginx
```

#### `docker push` - Subir imágenes

```bash
# Primero, login en el registro
docker login

# Etiquetar imagen
docker tag mi-app:latest usuario/mi-app:v1.0

# Subir imagen
docker push usuario/mi-app:v1.0

# Login en registro privado
docker login registry.miempresa.com
docker push registry.miempresa.com/mi-app:v1.0
```

#### `docker build` - Construir imágenes

```bash
# Construir desde Dockerfile en directorio actual
docker build -t mi-app:latest .

# Especificar Dockerfile
docker build -t mi-app:latest -f Dockerfile.prod .

# Con argumentos de construcción
docker build --build-arg VERSION=1.0 -t mi-app:latest .

# Sin usar caché
docker build --no-cache -t mi-app:latest .

# Ver salida detallada
docker build --progress=plain -t mi-app:latest .

# Etiquetar con múltiples tags
docker build -t mi-app:latest -t mi-app:v1.0 -t mi-app:stable .

# Construcción multi-arquitectura
docker buildx build --platform linux/amd64,linux/arm64 -t mi-app:latest .
```

#### `docker rmi` - Eliminar imágenes

```bash
# Eliminar imagen
docker rmi nginx:alpine

# Forzar eliminación
docker rmi -f mi-app:latest

# Eliminar múltiples imágenes
docker rmi nginx:alpine redis:7 postgres:15

# Eliminar imágenes dangling
docker rmi $(docker images -f "dangling=true" -q)

# Eliminar todas las imágenes
docker rmi $(docker images -q)
```

#### `docker tag` - Etiquetar imágenes

```bash
# Crear nueva etiqueta
docker tag mi-app:latest mi-app:v1.0

# Etiquetar para registro privado
docker tag mi-app:latest registry.miempresa.com/mi-app:latest

# Múltiples etiquetas
docker tag mi-app:latest mi-app:stable
docker tag mi-app:latest mi-app:production
```

---

## PARTE 4: Gestión de volúmenes y redes

### Volúmenes

#### `docker volume` - Comandos de volúmenes

```bash
# Listar volúmenes
docker volume ls

# Crear volumen
docker volume create mi_volumen

# Inspeccionar volumen
docker volume inspect mi_volumen

# Eliminar volumen
docker volume rm mi_volumen

# Eliminar volúmenes no usados
docker volume prune

# Eliminar volúmenes específicos
docker volume rm volumen1 volumen2
```

**Ejemplo de uso:**

```bash
# Crear volumen
docker volume create datos_postgres

# Usar en contenedor
docker run -d \
  --name postgres \
  -v datos_postgres:/var/lib/postgresql/data \
  postgres:15

# Inspeccionar
docker volume inspect datos_postgres

# Ver punto de montaje en el host
docker volume inspect datos_postgres --format '{{.Mountpoint}}'
```

### Redes

#### `docker network` - Comandos de redes

```bash
# Listar redes
docker network ls

# Crear red
docker network create mi_red

# Crear red con configuración específica
docker network create --driver bridge --subnet 172.20.0.0/16 mi_red

# Inspeccionar red
docker network inspect mi_red

# Conectar contenedor a red
docker network connect mi_red mi_contenedor

# Desconectar
docker network disconnect mi_red mi_contenedor

# Eliminar red
docker network rm mi_red

# Eliminar redes no usadas
docker network prune
```

**Ejemplo práctico:**

```bash
# Crear red personalizada
docker network create app_network

# Iniciar contenedores en la red
docker run -d --name db --network app_network postgres:15
docker run -d --name app --network app_network mi_aplicacion

# Ahora 'app' puede conectarse a 'db' usando el nombre como hostname
```

---

## PARTE 5: Comandos de limpieza y mantenimiento

#### `docker system prune` - Limpieza general

```bash
# Eliminar contenedores detenidos, redes no usadas, imágenes dangling
docker system prune

# También eliminar volúmenes no usados
docker system prune --volumes

# Eliminar TODO (incluye imágenes no usadas)
docker system prune -a

# Sin confirmación
docker system prune -f

# Filtrar por tiempo (más de 24h sin usar)
docker system prune --filter "until=24h"
```

#### `docker system df` - Uso de espacio

```bash
# Ver resumen de uso de espacio
docker system df

# Ver detalles por recurso
docker system df -v
```

**Salida típica:**
```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          10        5         2.5GB     1.2GB (48%)
Containers      8         3         100MB     80MB (80%)
Local Volumes   5         2         500MB     300MB (60%)
Build Cache     0         0         0B        0B
```

#### Comandos de limpieza específicos

```bash
# Eliminar contenedores detenidos
docker container prune

# Eliminar imágenes sin usar
docker image prune

# Eliminar imágenes dangling
docker image prune -a

# Eliminar volúmenes no usados
docker volume prune

# Eliminar redes no usadas
docker network prune

# Detener todos los contenedores
docker stop $(docker ps -q)

# Eliminar todos los contenedores
docker rm $(docker ps -aq)

# Eliminar todas las imágenes
docker rmi $(docker images -q)
```

---

## PARTE 6: Comandos de diagnóstico

#### `docker info` - Información del sistema

```bash
# Ver configuración completa de Docker
docker info

# Ver solo número de contenedores
docker info --format '{{.Containers}}'

# Ver versión del servidor
docker info --format '{{.ServerVersion}}'
```

#### `docker version` - Versión de Docker

```bash
# Ver versión completa (cliente y servidor)
docker version

# Solo versión del cliente
docker version --format '{{.Client.Version}}'

# Solo versión del servidor
docker version --format '{{.Server.Version}}'
```

#### `docker events` - Eventos en tiempo real

```bash
# Ver todos los eventos
docker events

# Filtrar por tipo
docker events --filter 'type=container'
docker events --filter 'type=image'
docker events --filter 'type=network'

# Filtrar por evento específico
docker events --filter 'event=start'
docker events --filter 'event=die'

# Desde una fecha
docker events --since '2024-01-01T00:00:00'
```

#### `docker top` - Procesos en contenedor

```bash
# Ver procesos en contenedor
docker top mi_contenedor

# Con opciones de ps
docker top mi_contenedor aux
```

#### `docker diff` - Cambios en sistema de archivos

```bash
# Ver qué archivos han cambiado en el contenedor
docker diff mi_contenedor
```

Símbolos:
- `A`: Archivo agregado
- `D`: Archivo eliminado
- `C`: Archivo modificado

---

## PARTE 7: Comandos útiles combinados

### Scripts de limpieza

```bash
# Limpieza completa y segura
#!/bin/bash
echo "Deteniendo contenedores..."
docker stop $(docker ps -q)

echo "Eliminando contenedores..."
docker rm $(docker ps -aq)

echo "Eliminando imágenes dangling..."
docker image prune -f

echo "Eliminando volúmenes no usados..."
docker volume prune -f

echo "Eliminando redes no usadas..."
docker network prune -f

echo "¡Limpieza completada!"
docker system df
```

### Backup de volúmenes

```bash
# Backup de volumen a archivo tar
docker run --rm \
  -v mi_volumen:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/mi_volumen_backup.tar.gz -C /data .

# Restaurar backup
docker run --rm \
  -v mi_volumen:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/mi_volumen_backup.tar.gz"
```

### Copiar archivos entre host y contenedor

```bash
# Copiar del host al contenedor
docker cp /ruta/local/archivo.txt mi_contenedor:/ruta/destino/

# Copiar del contenedor al host
docker cp mi_contenedor:/ruta/archivo.txt /ruta/local/

# Copiar directorio completo
docker cp /ruta/local/directorio mi_contenedor:/ruta/destino/
```

---

## Atajos y alias útiles

Agrega estos a tu `~/.bashrc` o `~/.zshrc`:

```bash
# Docker
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -q)'

# Docker Compose
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dcr='docker compose restart'
alias dcps='docker compose ps'

# Limpieza
alias dclean='docker system prune -af --volumes'
alias dimgclean='docker rmi $(docker images -f "dangling=true" -q)'
```

Recargar configuración:
```bash
source ~/.bashrc
```

---

## Resumen de comandos esenciales

### Los 10 comandos que usarás el 90% del tiempo

```bash
# 1. Iniciar servicios
docker compose up -d

# 2. Ver estado
docker compose ps

# 3. Ver logs
docker compose logs -f

# 4. Ejecutar comandos
docker compose exec web bash

# 5. Detener servicios
docker compose down

# 6. Reiniciar servicio
docker compose restart app

# 7. Ver imágenes
docker images

# 8. Ver contenedores
docker ps

# 9. Limpiar sistema
docker system prune

# 10. Ver logs de contenedor
docker logs -f mi_contenedor
```

---

## Próximos pasos

Ahora que dominas los comandos básicos, es momento de aprender las mejores prácticas:

1. ✅ ¿Qué es Docker?
2. ✅ ¿Qué es Docker Compose?
3. ✅ Instalación
4. ✅ **Comandos básicos** (este documento)
5. ⏭️ **Mejores prácticas** - Optimización, seguridad y organización

---

**💡 Consejo**: No intentes memorizar todos los comandos. Usa este documento como referencia y practica los comandos más comunes. Con el tiempo, los recordarás naturalmente.