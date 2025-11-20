# Mejores Prácticas de Docker y Docker Compose

## Introducción

Este documento recopila las mejores prácticas para trabajar con Docker y Docker Compose de manera eficiente, segura y profesional. Son el resultado de años de experiencia de la comunidad y te ayudarán a evitar errores comunes.

---

## PARTE 1: Organización de proyectos

### Estructura de directorios recomendada

Una estructura clara facilita el mantenimiento:

```
mi-proyecto/
├── docker-compose.yml           # Compose principal
├── docker-compose.override.yml  # Override para desarrollo (git ignore)
├── docker-compose.prod.yml      # Configuración de producción
├── .env                         # Variables de entorno (git ignore)
├── .env.example                 # Plantilla de variables (en git)
├── .dockerignore                # Archivos a excluir en build
├── README.md                    # Documentación del proyecto
│
├── services/                    # Servicios de la aplicación
│   ├── web/
│   │   ├── Dockerfile
│   │   ├── src/
│   │   └── requirements.txt
│   │
│   ├── api/
│   │   ├── Dockerfile
│   │   ├── src/
│   │   └── package.json
│   │
│   └── worker/
│       ├── Dockerfile
│       └── src/
│
├── config/                      # Archivos de configuración
│   ├── nginx/
│   │   └── nginx.conf
│   ├── postgres/
│   │   └── init.sql
│   └── redis/
│       └── redis.conf
│
├── scripts/                     # Scripts útiles
│   ├── backup.sh
│   ├── restore.sh
│   └── deploy.sh
│
└── volumes/                     # Datos locales (git ignore)
    ├── postgres/
    ├── redis/
    └── uploads/
```

### Separar configuraciones por entorno

**docker-compose.yml (base):**
```yaml
version: '3.8'

services:
  web:
    build: ./services/web
    environment:
      - NODE_ENV=${NODE_ENV}
    depends_on:
      - db
  
  db:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

**docker-compose.override.yml (desarrollo - se aplica automáticamente):**
```yaml
version: '3.8'

services:
  web:
    volumes:
      - ./services/web/src:/app/src  # Hot reload
    ports:
      - "3000:3000"
    environment:
      - DEBUG=true
      - LOG_LEVEL=debug
  
  db:
    ports:
      - "5432:5432"  # Acceso directo para desarrollo
```

**docker-compose.prod.yml (producción - usar explícitamente):**
```yaml
version: '3.8'

services:
  web:
    restart: always
    environment:
      - DEBUG=false
      - LOG_LEVEL=error
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
  
  db:
    restart: always
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
```

**Uso:**
```bash
# Desarrollo (usa automáticamente override)
docker compose up

# Producción
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Archivo .env

**.env (NO subir a git):**
```env
# Base de datos
POSTGRES_USER=usuario
POSTGRES_PASSWORD=password_super_secreto
POSTGRES_DB=mi_base_datos

# Aplicación
NODE_ENV=development
API_KEY=clave_secreta_api
SECRET_KEY=clave_secreta_session

# Puertos
WEB_PORT=3000
DB_PORT=5432
```

**.env.example (sí subir a git):**
```env
# Base de datos
POSTGRES_USER=usuario
POSTGRES_PASSWORD=cambiar_en_produccion
POSTGRES_DB=mi_base_datos

# Aplicación
NODE_ENV=development
API_KEY=tu_clave_api
SECRET_KEY=tu_clave_secreta

# Puertos
WEB_PORT=3000
DB_PORT=5432
```

**Usar en docker-compose.yml:**
```yaml
services:
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
```

### .dockerignore

Similar a `.gitignore`, evita copiar archivos innecesarios a las imágenes:

```
# .dockerignore

# Git
.git
.gitignore
.gitattributes

# Docker
Dockerfile
docker-compose*.yml
.dockerignore

# Dependencias
node_modules
__pycache__
*.pyc
venv
env

# IDE
.vscode
.idea
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Tests
tests/
*.test.js
coverage/

# Documentation
README.md
docs/

# Environment
.env
.env.local
```

---

## PARTE 2: Creación de Dockerfiles eficientes

### Principios básicos

1. **Usar imágenes base ligeras**
2. **Minimizar número de capas**
3. **Aprovechar cache de build**
4. **Ejecutar como usuario no-root**
5. **Multi-stage builds cuando sea posible**

### Ejemplo: Dockerfile mal optimizado

```dockerfile
# ❌ MAL - Imagen pesada, muchas capas, ineficiente

FROM ubuntu:latest

# Cada RUN crea una capa
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN apt-get install -y curl
RUN apt-get install -y git

# Copia todo (incluye archivos innecesarios)
COPY . /app

# Instala dependencias (invalida cache si cambia cualquier archivo)
WORKDIR /app
RUN pip3 install -r requirements.txt

# Corre como root (peligroso)
CMD ["python3", "app.py"]
```

**Problemas:**
- Imagen base pesada (ubuntu:latest ~70MB vs alpine ~5MB)
- Muchas capas RUN innecesarias
- Cache ineficiente
- Copia archivos innecesarios
- Corre como root

### Ejemplo: Dockerfile optimizado

```dockerfile
# ✅ BIEN - Imagen ligera, optimizada, segura

# Imagen base ligera
FROM python:3.11-alpine

# Información del mantenedor
LABEL maintainer="tu@email.com"

# Crear usuario no-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Establecer directorio de trabajo
WORKDIR /app

# Copiar solo requirements primero (aprovecha cache)
COPY requirements.txt .

# Instalar dependencias en una sola capa
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar código de la aplicación
COPY --chown=appuser:appgroup . .

# Cambiar a usuario no-root
USER appuser

# Exponer puerto (documentación)
EXPOSE 5000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Comando de ejecución
CMD ["python3", "app.py"]
```

**Mejoras:**
- ✅ Imagen Alpine (mucho más ligera)
- ✅ Comandos combinados en pocas capas
- ✅ Cache eficiente (requirements.txt copiado primero)
- ✅ Usuario no-root
- ✅ Healthcheck incluido

### Multi-stage builds

Ideal para reducir el tamaño final de la imagen:

```dockerfile
# ✅ EXCELENTE - Multi-stage para Node.js

# ===== STAGE 1: Builder =====
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package files
COPY package*.json ./

# Instalar dependencias (incluye devDependencies)
RUN npm ci

# Copiar código
COPY . .

# Build de la aplicación
RUN npm run build

# ===== STAGE 2: Production =====
FROM node:18-alpine AS production

# Crear usuario no-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copiar solo package files
COPY package*.json ./

# Instalar SOLO dependencias de producción
RUN npm ci --only=production && npm cache clean --force

# Copiar build desde stage anterior
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist

# Cambiar a usuario no-root
USER appuser

# Exponer puerto
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node healthcheck.js || exit 1

# Comando de ejecución
CMD ["node", "dist/main.js"]
```

**Ventajas:**
- Primera etapa: Entorno completo de build (node_modules completo, herramientas de desarrollo)
- Segunda etapa: Solo runtime y archivos necesarios
- Resultado: Imagen final mucho más pequeña y segura

### Ordenamiento de instrucciones

**Orden recomendado para aprovechar cache:**

```dockerfile
FROM base_image

# 1. Metadatos (cambian poco)
LABEL maintainer="tu@email.com"

# 2. Instalación de paquetes del sistema (cambian poco)
RUN apt-get update && apt-get install -y \
    paquete1 \
    paquete2 \
    && rm -rf /var/lib/apt/lists/*

# 3. Creación de usuarios (cambia poco)
RUN useradd -m appuser

# 4. Creación de directorios
WORKDIR /app

# 5. Archivos de dependencias (cambian moderadamente)
COPY requirements.txt package.json ./

# 6. Instalación de dependencias (cambia moderadamente)
RUN pip install -r requirements.txt

# 7. Código de la aplicación (cambia frecuentemente)
COPY . .

# 8. Compilación/Build (si es necesario)
RUN npm run build

# 9. Configuración final
USER appuser
EXPOSE 8000
CMD ["python", "app.py"]
```

**Lógica**: Las capas que cambian poco van primero, las que cambian mucho van al final.

---

## PARTE 3: Docker Compose - Mejores prácticas

### Naming conventions

```yaml
version: '3.8'

services:
  # Usa nombres descriptivos y consistentes
  web_frontend:
    image: nginx:alpine
    container_name: proyecto_web  # Opcional, pero útil
    
  api_backend:
    build: ./api
    container_name: proyecto_api
  
  db_postgres:
    image: postgres:15-alpine
    container_name: proyecto_db

# Nombres de volúmenes descriptivos
volumes:
  postgres_data:
  redis_cache:

# Nombres de redes descriptivos
networks:
  frontend:
  backend:
```

### Usar depends_on correctamente

```yaml
version: '3.8'

services:
  web:
    image: nginx
    depends_on:
      api:
        condition: service_healthy  # Espera a que esté healthy
      
  api:
    build: ./api
    depends_on:
      - db
      - redis
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
  
  db:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
```

**Nota**: `depends_on` solo controla el ORDEN de inicio, no garantiza que el servicio esté listo. Usa healthchecks para eso.

### Variables de entorno organizadas

```yaml
services:
  app:
    image: mi_app
    environment:
      # Método 1: Inline (para valores no sensibles)
      - NODE_ENV=production
      - LOG_LEVEL=info
      
      # Método 2: Desde .env (valores sensibles)
      - DB_PASSWORD=${DB_PASSWORD}
      - API_KEY=${API_KEY}
    
    # Método 3: Archivo completo
    env_file:
      - .env
      - .env.production
```

### Limitar recursos

```yaml
services:
  app:
    image: mi_app
    deploy:
      resources:
        limits:
          cpus: '1.0'        # Máximo 1 CPU
          memory: 512M       # Máximo 512MB RAM
        reservations:
          cpus: '0.5'        # Reservar 0.5 CPU
          memory: 256M       # Reservar 256MB RAM
    
    # Limitar logs para evitar llenar disco
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Redes segmentadas

```yaml
version: '3.8'

services:
  # Frontend accesible públicamente
  nginx:
    image: nginx:alpine
    networks:
      - frontend
    ports:
      - "80:80"
      - "443:443"
  
  # Backend solo accesible desde frontend
  api:
    build: ./api
    networks:
      - frontend
      - backend
  
  # Base de datos solo accesible desde backend
  db:
    image: postgres:15
    networks:
      - backend
    # NO exponer puertos públicamente

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # Sin acceso a internet
```

### Volúmenes bien configurados

```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    volumes:
      # Volumen nombrado (recomendado para datos)
      - postgres_data:/var/lib/postgresql/data
      
      # Bind mount para configuración (read-only)
      - ./config/postgres/postgresql.conf:/etc/postgresql/postgresql.conf:ro
      
      # Script de inicialización
      - ./config/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql:ro

volumes:
  postgres_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ./volumes/postgres  # Opcional: especificar ubicación
```

### Healthchecks efectivos

```yaml
services:
  web:
    image: nginx
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
  
  postgres:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
  
  redis:
    image: redis:alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
```

---

## PARTE 4: Seguridad

### Principio de mínimo privilegio

```yaml
services:
  app:
    image: mi_app
    
    # Deshabilitar privilegios especiales
    privileged: false
    
    # Limitar capabilities
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE  # Solo si necesita puertos < 1024
    
    # Solo lectura en root filesystem
    read_only: true
    
    # Directorio temporal escribible
    tmpfs:
      - /tmp
      - /var/run
    
    # Usuario no-root
    user: "1000:1000"
    
    # Prevenir escalación de privilegios
    security_opt:
      - no-new-privileges:true
```

### Secrets para datos sensibles

```yaml
version: '3.8'

services:
  app:
    image: mi_app
    secrets:
      - db_password
      - api_key
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
      - API_KEY_FILE=/run/secrets/api_key

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    file: ./secrets/api_key.txt
```

**En la aplicación:**
```python
# Leer secret desde archivo
with open('/run/secrets/db_password', 'r') as f:
    db_password = f.read().strip()
```

### Escaneo de vulnerabilidades

```bash
# Escanear imagen con Docker Scout
docker scout cves mi_app:latest

# Escanear con Trivy
trivy image mi_app:latest

# Ver solo vulnerabilidades HIGH y CRITICAL
trivy image --severity HIGH,CRITICAL mi_app:latest
```

### Firma de imágenes

```bash
# Habilitar Docker Content Trust
export DOCKER_CONTENT_TRUST=1

# Todas las pulls verificarán firmas
docker pull nginx:alpine

# Todas las pushes requerirán firma
docker push mi_usuario/mi_app:latest
```

### Políticas de acceso

```yaml
services:
  app:
    image: mi_app
    
    # Solo lectura en volúmenes cuando sea posible
    volumes:
      - config:/app/config:ro
      
    # Red sin acceso a internet
    networks:
      - internal
    
    # Sin escalación de privilegios
    security_opt:
      - no-new-privileges:true
      - seccomp:unconfined  # Solo si es necesario
```

---

## PARTE 5: Performance y optimización

### Optimizar tamaño de imágenes

```dockerfile
# ANTES: 1.2 GB
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y python3 python3-pip
COPY . /app
RUN pip3 install -r requirements.txt

# DESPUÉS: 250 MB
FROM python:3.11-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
```

**Técnicas:**
- Usar imágenes Alpine
- Multi-stage builds
- Eliminar cache de package managers
- No instalar herramientas innecesarias

### BuildKit para builds más rápidos

```bash
# Habilitar BuildKit (más rápido y eficiente)
export DOCKER_BUILDKIT=1

# Build con BuildKit
docker build -t mi_app .

# Docker Compose con BuildKit
COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker compose build
```

**Ventajas de BuildKit:**
- Builds paralelos
- Cache mejorado
- Detección automática de dependencias
- Salida más clara

### Cache de dependencias

```dockerfile
# ✅ BIEN - Dependencias cacheadas
FROM node:18-alpine
WORKDIR /app

# Copiar solo package.json primero
COPY package*.json ./
RUN npm ci

# Código después (cambia más frecuentemente)
COPY . .
RUN npm run build
```

Si cambias el código pero no las dependencias, `npm ci` usa cache.

### Shared volumes para desarrollo

```yaml
version: '3.8'

services:
  web:
    build: ./web
    volumes:
      # Bind mount del código para hot reload
      - ./web/src:/app/src
      
      # Volumen anónimo para node_modules (evita sobrescribir)
      - /app/node_modules
```

### Logging eficiente

```yaml
services:
  app:
    image: mi_app
    logging:
      driver: "json-file"
      options:
        max-size: "10m"    # Máximo 10MB por archivo
        max-file: "3"      # Mantener 3 archivos
        compress: "true"   # Comprimir logs antiguos
```

O usa un driver de logging centralizado:

```yaml
services:
  app:
    image: mi_app
    logging:
      driver: "syslog"
      options:
        syslog-address: "tcp://192.168.1.100:514"
        tag: "{{.Name}}/{{.ID}}"
```

---

## PARTE 6: Desarrollo vs Producción

### Configuración de desarrollo

```yaml
# docker-compose.override.yml (desarrollo)
version: '3.8'

services:
  web:
    build:
      context: ./web
      dockerfile: Dockerfile.dev  # Dockerfile específico para dev
    
    volumes:
      - ./web/src:/app/src        # Hot reload
      - /app/node_modules          # No sobrescribir
    
    ports:
      - "3000:3000"                # Exponer para debugging
      - "9229:9229"                # Debug port para Node.js
    
    environment:
      - NODE_ENV=development
      - DEBUG=*
      - LOG_LEVEL=debug
    
    command: npm run dev
```

### Configuración de producción

```yaml
# docker-compose.prod.yml (producción)
version: '3.8'

services:
  web:
    build:
      context: ./web
      dockerfile: Dockerfile       # Dockerfile optimizado
    
    restart: always
    
    # Sin bind mounts (código en la imagen)
    # Sin puertos expuestos (detrás de proxy)
    
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=error
    
    deploy:
      replicas: 3                  # Múltiples instancias
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
    
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

---

## PARTE 7: Monitoreo y observabilidad

### Logs centralizados

```yaml
version: '3.8'

services:
  app:
    image: mi_app
    logging:
      driver: "fluentd"
      options:
        fluentd-address: localhost:24224
        tag: app.logs

  fluentd:
    image: fluent/fluentd:latest
    ports:
      - "24224:24224"
    volumes:
      - ./config/fluentd:/fluentd/etc
      - logs:/fluentd/log

volumes:
  logs:
```

### Métricas con Prometheus

```yaml
version: '3.8'

services:
  # Tu aplicación
  app:
    image: mi_app
    expose:
      - 9090  # Puerto de métricas

  # Prometheus para recopilar métricas
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  # Grafana para visualización
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

### Healthchecks avanzados

```yaml
services:
  app:
    image: mi_app
    healthcheck:
      test: |
        curl -f http://localhost:3000/health || exit 1
        curl -f http://localhost:3000/readiness || exit 1
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

---

## PARTE 8: Backup y recuperación

### Script de backup

```bash
#!/bin/bash
# backup.sh

# Variables
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
PROJECT_NAME="mi_proyecto"

# Crear directorio de backup
mkdir -p "$BACKUP_DIR"

# Backup de volúmenes
echo "Backing up volumes..."
docker run --rm \
  -v "${PROJECT_NAME}_postgres_data:/data" \
  -v "$BACKUP_DIR:/backup" \
  alpine tar czf "/backup/postgres_${DATE}.tar.gz" -C /data .

docker run --rm \
  -v "${PROJECT_NAME}_redis_cache:/data" \
  -v "$BACKUP_DIR:/backup" \
  alpine tar czf "/backup/redis_${DATE}.tar.gz" -C /data .

# Backup de configuración
echo "Backing up configs..."
tar czf "$BACKUP_DIR/config_${DATE}.tar.gz" \
  docker-compose.yml \
  .env \
  config/

# Eliminar backups antiguos (más de 7 días)
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR"
```

### Script de restore

```bash
#!/bin/bash
# restore.sh

BACKUP_FILE=$1
PROJECT_NAME="mi_proyecto"

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 <backup_file.tar.gz>"
  exit 1
fi

# Detener servicios
echo "Stopping services..."
docker compose down

# Restaurar volumen
echo "Restoring data..."
docker run --rm \
  -v "${PROJECT_NAME}_postgres_data:/data" \
  -v "$(pwd):/backup" \
  alpine sh -c "cd /data && tar xzf /backup/$BACKUP_FILE"

# Iniciar servicios
echo "Starting services..."
docker compose up -d

echo "Restore completed"
```

---

## PARTE 9: CI/CD con Docker

### GitHub Actions ejemplo

```yaml
# .github/workflows/docker.yml
name: Docker Build and Push

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Build and push
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: |
          usuario/mi-app:latest
          usuario/mi-app:${{ github.sha }}
        cache-from: type=registry,ref=usuario/mi-app:latest
        cache-to: type=inline
```

---

## PARTE 10: Troubleshooting

### Checklist de problemas comunes

#### Contenedor no inicia

```bash
# 1. Ver logs detallados
docker compose logs servicio

# 2. Ver eventos
docker events --filter container=nombre_contenedor

# 3. Intentar ejecutar el comando manualmente
docker compose run --rm servicio bash

# 4. Verificar healthcheck
docker inspect --format='{{json .State.Health}}' contenedor
```

#### Problemas de red

```bash
# 1. Verificar conectividad entre contenedores
docker compose exec servicio1 ping servicio2

# 2. Ver redes
docker network ls
docker network inspect nombre_red

# 3. Verificar DNS
docker compose exec servicio nslookup otro_servicio
```

#### Problemas de volúmenes

```bash
# 1. Verificar permisos
docker compose exec servicio ls -la /ruta/montada

# 2. Ver volúmenes
docker volume ls
docker volume inspect nombre_volumen

# 3. Verificar uso de espacio
docker system df -v
```

#### Performance lento

```bash
# 1. Ver uso de recursos
docker stats

# 2. Ver logs de Docker daemon
sudo journalctl -u docker -f

# 3. Verificar límites de recursos
docker inspect --format='{{.HostConfig.Memory}}' contenedor
```

---

## Checklist final de mejores prácticas

### Dockerfile
- ✅ Usar imágenes base ligeras (Alpine)
- ✅ Multi-stage builds cuando sea posible
- ✅ Minimizar número de capas
- ✅ Ordenar instrucciones para optimizar cache
- ✅ Ejecutar como usuario no-root
- ✅ Usar .dockerignore
- ✅ Incluir healthcheck
- ✅ Limpiar cache de package managers

### Docker Compose
- ✅ Separar configuración por entornos
- ✅ Usar .env para secretos (no commitear)
- ✅ Implementar healthchecks
- ✅ Segmentar redes (frontend/backend)
- ✅ Usar volúmenes nombrados para datos
- ✅ Limitar recursos
- ✅ Configurar logging
- ✅ Usar depends_on con conditions

### Seguridad
- ✅ No ejecutar como root
- ✅ Escanear vulnerabilidades
- ✅ Limitar capabilities
- ✅ Usar secrets para datos sensibles
- ✅ Firmar imágenes
- ✅ Mantener imágenes actualizadas
- ✅ No exponer puertos innecesarios

### Operaciones
- ✅ Implementar backups automáticos
- ✅ Monitorear logs y métricas
- ✅ Documentar configuración
- ✅ Versionad configuración en Git
- ✅ Limpiar recursos no usados
- ✅ Implementar CI/CD

---

## Recursos adicionales

### Documentación oficial
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

### Herramientas útiles
- **Dive**: Analizar capas de imágenes
- **Trivy**: Escaneo de vulnerabilidades
- **Hadolint**: Linter para Dockerfiles
- **Docker Scout**: Análisis de seguridad

### Comunidad
- [Docker Forums](https://forums.docker.com/)
- [Stack Overflow - Docker](https://stackoverflow.com/questions/tagged/docker)
- [Reddit r/docker](https://www.reddit.com/r/docker/)

---

## Conclusión

Has completado la guía de fundamentos de Docker y Docker Compose. Con estos conocimientos puedes:

1. ✅ Entender qué es Docker y sus conceptos fundamentales
2. ✅ Comprender Docker Compose y cuándo usarlo
3. ✅ Instalar y configurar Docker correctamente
4. ✅ Usar comandos esenciales con confianza
5. ✅ Aplicar mejores prácticas de seguridad y optimización

**Próximos pasos sugeridos:**
- Practica creando tu primer proyecto completo
- Experimenta con diferentes stacks (LAMP, MEAN, etc.)
- Aprende sobre orquestación (Kubernetes, Docker Swarm)
- Implementa CI/CD en tus proyectos

---

**💡 Recuerda**: La mejor forma de aprender es practicando. No tengas miedo de experimentar y cometer errores en entornos de desarrollo.

¡Buena suerte con tus proyectos Docker! 🐳