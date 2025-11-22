# ¿Qué es Docker Compose?

## Introducción

**Docker Compose** es una herramienta que permite definir y ejecutar aplicaciones Docker multi-contenedor. En lugar de ejecutar múltiples comandos `docker run` complejos, defines todo en un archivo YAML y lo ejecutas con un solo comando.

## El problema que resuelve

### Sin Docker Compose

Imagina que tienes una aplicación web que necesita:
- Un contenedor con tu aplicación web (Node.js)
- Un contenedor con base de datos (PostgreSQL)
- Un contenedor con cache (Redis)
- Un contenedor con servidor proxy (Nginx)

Tendrías que ejecutar algo como esto:

```bash
# 1. Crear red
docker network create mi_red

# 2. Crear volúmenes
docker volume create datos_postgres
docker volume create datos_redis

# 3. Iniciar PostgreSQL
docker run -d \
  --name postgres \
  --network mi_red \
  -v datos_postgres:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=secreto \
  -e POSTGRES_DB=miapp \
  postgres:15

# 4. Iniciar Redis
docker run -d \
  --name redis \
  --network mi_red \
  -v datos_redis:/data \
  redis:7-alpine

# 5. Iniciar aplicación
docker run -d \
  --name app \
  --network mi_red \
  -e DATABASE_URL=postgres://postgres:secreto@postgres:5432/miapp \
  -e REDIS_URL=redis://redis:6379 \
  mi_aplicacion:latest

# 6. Iniciar Nginx
docker run -d \
  --name nginx \
  --network mi_red \
  -p 80:80 \
  -v ./nginx.conf:/etc/nginx/nginx.conf \
  nginx:alpine
```

**Problemas:**
- ✗ Muchos comandos difíciles de recordar
- ✗ Fácil cometer errores de tipeo
- ✗ Difícil de compartir con tu equipo
- ✗ Complicado de mantener y actualizar
- ✗ No hay orden de inicio garantizado

### Con Docker Compose

El mismo resultado con un archivo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secreto
      POSTGRES_DB: miapp
    volumes:
      - datos_postgres:/var/lib/postgresql/data
    networks:
      - mi_red

  redis:
    image: redis:7-alpine
    volumes:
      - datos_redis:/data
    networks:
      - mi_red

  app:
    image: mi_aplicacion:latest
    environment:
      DATABASE_URL: postgres://postgres:secreto@postgres:5432/miapp
      REDIS_URL: redis://redis:6379
    depends_on:
      - postgres
      - redis
    networks:
      - mi_red

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - app
    networks:
      - mi_red

networks:
  mi_red:

volumes:
  datos_postgres:
  datos_redis:
```

Y ejecutarlo con:

```bash
docker compose up -d
```

**Ventajas:**
- ✓ Todo en un archivo legible y organizado
- ✓ Un solo comando para iniciar todo
- ✓ Fácil de compartir y versionar
- ✓ Gestión automática de dependencias
- ✓ Menos propenso a errores

## Características principales

### 1. Definición declarativa

En lugar de decir "cómo" hacer las cosas paso a paso (imperativo), describes "qué" quieres que exista (declarativo):

```yaml
# Dices QUÉ quieres
services:
  web:
    image: nginx
    ports:
      - "80:80"

# Docker Compose decide CÓMO hacerlo
```

### 2. Gestión del ciclo de vida

Docker Compose maneja todo el ciclo de vida de tu aplicación:

```bash
# Iniciar todos los servicios
docker compose up

# Detener todos los servicios
docker compose down

# Ver el estado
docker compose ps

# Ver logs de todos los servicios
docker compose logs

# Reiniciar un servicio específico
docker compose restart app
```

### 3. Aislamiento de entornos

Puedes tener múltiples proyectos ejecutándose sin que interfieran entre sí:

```
proyecto1/
├── docker-compose.yml
└── ...

proyecto2/
├── docker-compose.yml
└── ...
```

Docker Compose crea redes y contenedores con nombres únicos para cada proyecto.

### 4. Configuración de múltiples entornos

Puedes tener diferentes configuraciones para desarrollo, pruebas y producción:

```yaml
# docker-compose.yml (base)
services:
  app:
    image: mi_app
    
# docker-compose.override.yml (desarrollo - se aplica automáticamente)
services:
  app:
    volumes:
      - .:/app  # Monta código local para desarrollo
    environment:
      DEBUG: "true"

# docker-compose.prod.yml (producción - usar explícitamente)
services:
  app:
    environment:
      DEBUG: "false"
    deploy:
      replicas: 3
```

Uso:
```bash
# Desarrollo (usa automáticamente override)
docker compose up

# Producción (especifica el archivo)
docker compose -f docker-compose.yml -f docker-compose.prod.yml up
```

## Anatomía de un archivo docker-compose.yml

### Estructura básica

```yaml
version: '3.8'  # Versión del formato de Compose

services:       # Define los contenedores
  servicio1:
    # Configuración del servicio
  
  servicio2:
    # Configuración del servicio

networks:       # Define redes personalizadas (opcional)
  red1:

volumes:        # Define volúmenes (opcional)
  volumen1:

configs:        # Configuraciones compartidas (opcional)

secrets:        # Datos sensibles (opcional)
```

### Sección de servicios

Cada servicio es un contenedor. Opciones comunes:

```yaml
services:
  mi_servicio:
    # --- IMAGEN ---
    image: nginx:alpine              # Usar imagen existente
    # O
    build:                           # Construir desde Dockerfile
      context: ./app
      dockerfile: Dockerfile
      args:
        VERSION: "1.0"
    
    # --- NOMBRE DEL CONTENEDOR ---
    container_name: mi_contenedor    # Nombre específico (opcional)
    
    # --- PUERTOS ---
    ports:
      - "8080:80"                    # host:contenedor
      - "443:443"
    
    # --- VARIABLES DE ENTORNO ---
    environment:
      NODE_ENV: production
      API_KEY: mi_clave
    # O desde archivo
    env_file:
      - .env
    
    # --- VOLÚMENES ---
    volumes:
      - ./data:/app/data             # Bind mount
      - datos_app:/var/lib/app       # Volumen nombrado
    
    # --- REDES ---
    networks:
      - frontend
      - backend
    
    # --- DEPENDENCIAS ---
    depends_on:
      - base_datos
      - cache
    
    # --- REINICIO ---
    restart: unless-stopped           # always, on-failure, unless-stopped
    
    # --- COMANDO ---
    command: npm start                # Sobrescribe CMD del Dockerfile
    
    # --- LÍMITES DE RECURSOS ---
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

### Sección de networks

Define redes personalizadas para comunicación entre servicios:

```yaml
networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
  
  backend:
    driver: bridge
    internal: true  # Solo comunicación interna, sin acceso a internet
```

### Sección de volumes

Define volúmenes para persistencia de datos:

```yaml
volumes:
  datos_postgres:
    driver: local
  
  datos_compartidos:
    driver: local
    driver_opts:
      type: nfs
      o: addr=192.168.1.100,rw
      device: ":/path/to/dir"
```

## Casos de uso comunes

### 1. Aplicación web completa (LAMP Stack)

```yaml
version: '3.8'

services:
  # Servidor web Apache + PHP
  web:
    image: php:8.2-apache
    ports:
      - "80:80"
    volumes:
      - ./app:/var/www/html
    depends_on:
      - db
    networks:
      - lamp

  # Base de datos MySQL
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: mi_base_datos
      MYSQL_USER: usuario
      MYSQL_PASSWORD: password
    volumes:
      - datos_mysql:/var/lib/mysql
    networks:
      - lamp

  # Administrador de BD
  phpmyadmin:
    image: phpmyadmin:latest
    ports:
      - "8080:80"
    environment:
      PMA_HOST: db
      PMA_USER: usuario
      PMA_PASSWORD: password
    depends_on:
      - db
    networks:
      - lamp

networks:
  lamp:

volumes:
  datos_mysql:
```

### 2. Stack de desarrollo Node.js

```yaml
version: '3.8'

services:
  # Aplicación Node.js
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules  # Evita sobrescribir node_modules
    environment:
      NODE_ENV: development
      DATABASE_URL: postgres://postgres:password@db:5432/miapp
      REDIS_URL: redis://redis:6379
    depends_on:
      - db
      - redis
    command: npm run dev  # Hot reload en desarrollo

  # Base de datos PostgreSQL
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: miapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"  # Expuesto para herramientas externas

  # Cache Redis
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

### 3. Stack de monitoreo

```yaml
version: '3.8'

services:
  # Prometheus (métricas)
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  # Grafana (visualización)
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus

  # Node Exporter (métricas del sistema)
  node_exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"

volumes:
  prometheus_data:
  grafana_data:
```

## Docker Compose vs Docker CLI

| Aspecto | Docker CLI | Docker Compose |
|---------|-----------|----------------|
| **Archivo de configuración** | No (comandos) | Sí (YAML) |
| **Múltiples contenedores** | Comando por contenedor | Un comando para todos |
| **Versionado** | Difícil | Fácil (archivo en Git) |
| **Compartir configuración** | Scripts bash complejos | Archivo YAML simple |
| **Curva de aprendizaje** | Más empinada | Más suave |
| **Casos de uso** | Contenedores individuales | Aplicaciones completas |

## Versiones de Docker Compose

### Docker Compose V1 (legacy)

```bash
# Instalación separada
docker-compose up

# Formato de comando con guion
docker-compose down
```

### Docker Compose V2 (actual)

```bash
# Integrado en Docker CLI
docker compose up

# Formato de comando sin guion (subcomando de docker)
docker compose down
```

**💡 Nota**: Actualmente Docker Compose V2 es el estándar. Los ejemplos en esta guía usan V2.

## Ventajas y limitaciones

### Ventajas

✅ **Simplicidad**: Un archivo para toda la aplicación
✅ **Reproducibilidad**: Mismo entorno en cualquier máquina
✅ **Versionado**: El archivo se versiona con tu código
✅ **Documentación**: El YAML documenta la arquitectura
✅ **Desarrollo local**: Perfecto para desarrollo y pruebas
✅ **Integración CI/CD**: Fácil de usar en pipelines

### Limitaciones

❌ **No es para producción a gran escala**: Para eso existen Kubernetes, Docker Swarm
❌ **Una sola máquina**: No orquesta múltiples servidores (por defecto)
❌ **Gestión limitada**: Sin auto-scaling, auto-healing avanzado
❌ **Recursos**: Todos los contenedores en la misma máquina

**¿Cuándo usar Docker Compose?**
- ✅ Desarrollo local
- ✅ Testing/QA
- ✅ Aplicaciones pequeñas en un solo servidor
- ✅ Prototipos y demos

**¿Cuándo NO usar Docker Compose?**
- ❌ Producción con alta disponibilidad
- ❌ Aplicaciones distribuidas en múltiples servidores
- ❌ Necesitas auto-scaling automático
- ❌ Aplicaciones críticas que requieren orquestación avanzada

## Flujo de trabajo típico

```
1. Desarrollar aplicación
   └── Crear código, Dockerfile, etc.

2. Definir servicios
   └── Crear docker-compose.yml

3. Construir imágenes (si es necesario)
   └── docker compose build

4. Iniciar servicios
   └── docker compose up -d

5. Desarrollar/probar
   └── Hacer cambios, ver logs, debuggear

6. Detener servicios
   └── docker compose down

7. (Opcional) Limpiar todo
   └── docker compose down -v  # Elimina también volúmenes
```

## Comandos básicos adelanto

Un vistazo rápido a los comandos más usados:

```bash
# Iniciar servicios
docker compose up -d

# Ver servicios activos
docker compose ps

# Ver logs
docker compose logs -f

# Detener servicios (conserva volúmenes)
docker compose down

# Detener y eliminar volúmenes
docker compose down -v

# Reconstruir imágenes
docker compose build

# Reiniciar un servicio
docker compose restart app

# Ejecutar comando en servicio
docker compose exec app bash
```

**Nota**: Los veremos en detalle en el documento de comandos básicos.

## Ejemplo práctico: WordPress + MySQL

Este es un ejemplo real y funcional que puedes probar:

```yaml
version: '3.8'

services:
  # Base de datos
  db:
    image: mysql:8.0
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  # WordPress
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html

volumes:
  db_data:
  wordpress_data:
```

**Para usar este ejemplo:**

```bash
# 1. Guarda el contenido en docker-compose.yml
# 2. En la misma carpeta, ejecuta:
docker compose up -d

# 3. Abre tu navegador en:
# http://localhost:8000

# 4. Cuando termines:
docker compose down
```

## Resumen

**Docker Compose es:**
- Una herramienta para definir aplicaciones multi-contenedor
- Un archivo YAML que describe toda tu infraestructura
- Una forma simple de gestionar entornos complejos

**Te permite:**
- ✓ Definir múltiples servicios en un solo archivo
- ✓ Iniciar/detener toda tu aplicación con un comando
- ✓ Compartir configuraciones fácilmente
- ✓ Mantener entornos consistentes

**Es perfecto para:**
- Desarrollo local
- Testing
- Pequeñas aplicaciones en producción
- Aprender Docker

## Próximos pasos

Ahora que entiendes qué es Docker Compose, continuemos con:

1. ✅ ¿Qué es Docker? (documento anterior)
2. ✅ **¿Qué es Docker Compose?** (este documento)
3. ⏭️ **Instalación** - Instalar Docker y Docker Compose
4. ⏭️ **Comandos básicos** - Dominar las operaciones diarias
5. ⏭️ **Mejores prácticas** - Optimizar y asegurar tus contenedores

---

**💡 Consejo**: Practica creando tu primer `docker-compose.yml` simple. La mejor forma de aprender es experimentando.