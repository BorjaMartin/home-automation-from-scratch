# Ejercicios Prácticos de Docker y Docker Compose

## 📝 Introducción

Este documento contiene ejercicios prácticos organizados por nivel de dificultad. Cada ejercicio incluye:
- **Objetivo**: Qué aprenderás
- **Requisitos**: Conocimientos previos necesarios
- **Pasos**: Instrucciones detalladas
- **Verificación**: Cómo comprobar que funciona
- **Reto adicional**: Para profundizar

---

## 🟢 NIVEL BÁSICO

### Ejercicio 1: Tu primer contenedor

**Objetivo**: Familiarizarte con `docker run` y comandos básicos

**Requisitos**: Docker instalado

**Pasos**:

1. Ejecuta tu primer contenedor:
```bash
docker run hello-world
```

2. Ejecuta un servidor web nginx:
```bash
docker run -d -p 8080:80 --name mi_nginx nginx:alpine
```

3. Verifica que está corriendo:
```bash
docker ps
```

4. Abre tu navegador en `http://localhost:8080`

5. Ve los logs:
```bash
docker logs mi_nginx
```

6. Detén y elimina el contenedor:
```bash
docker stop mi_nginx
docker rm mi_nginx
```

**Verificación**: ¿Viste la página de bienvenida de nginx?

**Reto adicional**: 
- Ejecuta nginx en el puerto 9000
- Nombra el contenedor "servidor_web"
- Configúralo para que se reinicie automáticamente

<details>
<summary>Ver solución del reto</summary>

```bash
docker run -d -p 9000:80 --name servidor_web --restart=always nginx:alpine
```
</details>

---

### Ejercicio 2: Interactuando con contenedores

**Objetivo**: Aprender a ejecutar comandos dentro de contenedores

**Pasos**:

1. Ejecuta un contenedor Ubuntu en modo interactivo:
```bash
docker run -it --name mi_ubuntu ubuntu:22.04 bash
```

2. Dentro del contenedor, ejecuta:
```bash
apt update
apt install -y curl
curl ifconfig.me
echo "Hola Docker" > /tmp/mensaje.txt
cat /tmp/mensaje.txt
exit
```

3. Vuelve a iniciar el contenedor:
```bash
docker start mi_ubuntu
```

4. Ejecuta comandos sin entrar al contenedor:
```bash
docker exec mi_ubuntu cat /tmp/mensaje.txt
docker exec mi_ubuntu ls -la /tmp
```

5. Limpieza:
```bash
docker stop mi_ubuntu
docker rm mi_ubuntu
```

**Reto adicional**:
- Instala Python en el contenedor
- Crea un script Python que imprima "Hello Docker"
- Ejecútalo desde fuera del contenedor

---

### Ejercicio 3: Tu primer docker-compose

**Objetivo**: Crear tu primer archivo docker-compose.yml

**Pasos**:

1. Crea un directorio para el proyecto:
```bash
mkdir mi_primer_compose
cd mi_primer_compose
```

2. Crea un archivo `docker-compose.yml`:
```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
```

3. Crea contenido HTML:
```bash
mkdir html
cat > html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Mi primer Docker Compose</title>
</head>
<body>
    <h1>¡Funciona!</h1>
    <p>Este es mi primer proyecto con Docker Compose</p>
</body>
</html>
EOF
```

4. Inicia el servicio:
```bash
docker compose up -d
```

5. Verifica en `http://localhost:8080`

6. Ve los logs:
```bash
docker compose logs -f
```

7. Detén todo:
```bash
docker compose down
```

**Reto adicional**:
- Agrega un segundo servicio con otra instancia de nginx en puerto 8081
- Crea páginas diferentes para cada servicio

---

### Ejercicio 4: Volúmenes persistentes

**Objetivo**: Entender cómo persisten los datos

**Pasos**:

1. Crea un proyecto con base de datos:
```yaml
# docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: mipassword
      POSTGRES_USER: usuario
      POSTGRES_DB: midb
    volumes:
      - datos_postgres:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  datos_postgres:
```

2. Inicia el servicio:
```bash
docker compose up -d
```

3. Conéctate y crea datos:
```bash
docker compose exec db psql -U usuario -d midb -c "CREATE TABLE test (id SERIAL PRIMARY KEY, nombre TEXT);"
docker compose exec db psql -U usuario -d midb -c "INSERT INTO test (nombre) VALUES ('Docker'), ('Compose');"
docker compose exec db psql -U usuario -d midb -c "SELECT * FROM test;"
```

4. Destruye el contenedor:
```bash
docker compose down
```

5. Vuelve a iniciar:
```bash
docker compose up -d
```

6. Verifica que los datos persisten:
```bash
docker compose exec db psql -U usuario -d midb -c "SELECT * FROM test;"
```

**Reto adicional**:
- Elimina todo incluyendo volúmenes (`docker compose down -v`)
- Vuelve a iniciar y verifica que los datos se perdieron
- Investiga la diferencia entre volúmenes y bind mounts

---

## 🟡 NIVEL INTERMEDIO

### Ejercicio 5: Stack LAMP completo

**Objetivo**: Crear una aplicación web completa con múltiples servicios

**Pasos**:

1. Estructura del proyecto:
```bash
mkdir lamp_stack
cd lamp_stack
mkdir www
```

2. Crea `docker-compose.yml`:
```yaml
version: '3.8'

services:
  web:
    image: php:8.2-apache
    ports:
      - "80:80"
    volumes:
      - ./www:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: aplicacion
      MYSQL_USER: usuario
      MYSQL_PASSWORD: password
    volumes:
      - mysql_data:/var/lib/mysql

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

volumes:
  mysql_data:
```

3. Crea un archivo PHP de prueba:
```php
<?php
// www/index.php
$host = 'db';
$user = 'usuario';
$pass = 'password';
$db = 'aplicacion';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    echo "<h1>✅ Conexión exitosa a MySQL</h1>";
    
    // Crear tabla
    $pdo->exec("CREATE TABLE IF NOT EXISTS visitas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    // Registrar visita
    $pdo->exec("INSERT INTO visitas (fecha) VALUES (NOW())");
    
    // Contar visitas
    $stmt = $pdo->query("SELECT COUNT(*) as total FROM visitas");
    $row = $stmt->fetch();
    
    echo "<p>Número de visitas: " . $row['total'] . "</p>";
    echo "<p>phpMyAdmin disponible en: <a href='http://localhost:8080'>localhost:8080</a></p>";
    
} catch(PDOException $e) {
    echo "<h1>❌ Error de conexión</h1>";
    echo "<p>" . $e->getMessage() . "</p>";
}
?>
```

4. Inicia el stack:
```bash
docker compose up -d
```

5. Accede a:
   - Aplicación: `http://localhost`
   - phpMyAdmin: `http://localhost:8080`

**Reto adicional**:
- Agrega Redis como cache
- Crea un script que use Redis para cachear resultados
- Implementa un sistema de login simple

---

### Ejercicio 6: Aplicación Node.js con hot reload

**Objetivo**: Configurar entorno de desarrollo con recarga automática

**Pasos**:

1. Estructura:
```bash
mkdir node_app
cd node_app
mkdir src
```

2. Crea `package.json`:
```json
{
  "name": "docker-node-app",
  "version": "1.0.0",
  "main": "src/index.js",
  "scripts": {
    "dev": "nodemon src/index.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.0"
  }
}
```

3. Crea `src/index.js`:
```javascript
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.json({ 
        mensaje: '¡Hola Docker!',
        timestamp: new Date()
    });
});

app.get('/health', (req, res) => {
    res.json({ status: 'ok' });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});
```

4. Crea `Dockerfile`:
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
```

5. Crea `docker-compose.yml`:
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - ./src:/app/src
      - /app/node_modules
    environment:
      - NODE_ENV=development
```

6. Construye e inicia:
```bash
docker compose up --build
```

7. Prueba el hot reload:
   - Modifica el mensaje en `src/index.js`
   - Guarda el archivo
   - Recarga `http://localhost:3000`

**Reto adicional**:
- Agrega MongoDB al stack
- Crea endpoints CRUD para una colección
- Implementa variables de entorno con `.env`

---

### Ejercicio 7: Redes y comunicación entre contenedores

**Objetivo**: Entender cómo se comunican los contenedores

**Pasos**:

1. Crea `docker-compose.yml`:
```yaml
version: '3.8'

services:
  frontend:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - frontend
    depends_on:
      - backend

  backend:
    image: node:18-alpine
    command: sh -c "
      echo 'const http = require(\"http\");
      const server = http.createServer((req, res) => {
        res.writeHead(200);
        res.end(JSON.stringify({mensaje: \"Hola desde backend\"}));
      });
      server.listen(3000, \"0.0.0.0\");
      console.log(\"Backend en puerto 3000\");' > app.js && node app.js"
    networks:
      - frontend
      - backend

  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
    networks:
      - backend

networks:
  frontend:
  backend:
    internal: true  # Sin acceso a internet
```

2. Crea `nginx.conf`:
```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
        }
    }
}
```

3. Inicia y prueba:
```bash
docker compose up -d
curl http://localhost
```

4. Verifica conectividad:
```bash
# Frontend puede alcanzar backend
docker compose exec frontend ping -c 3 backend

# Backend puede alcanzar database
docker compose exec backend ping -c 3 database

# Frontend NO puede alcanzar database (diferentes redes)
docker compose exec frontend ping -c 3 database  # Debería fallar
```

**Reto adicional**:
- Agrega un servicio de cache (Redis)
- Modifica backend para usar cache
- Implementa balanceo de carga con múltiples backends

---

## 🔴 NIVEL AVANZADO

### Ejercicio 8: Multi-stage build optimizado

**Objetivo**: Crear imágenes mínimas y eficientes

**Pasos**:

1. Crea una aplicación Go simple:
```go
// main.go
package main

import (
    "fmt"
    "net/http"
    "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
    hostname, _ := os.Hostname()
    fmt.Fprintf(w, "Hola desde %s\n", hostname)
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Servidor en puerto 8080")
    http.ListenAndServe(":8080", nil)
}
```

2. Crea `Dockerfile` SIN multi-stage (malo):
```dockerfile
FROM golang:1.21
WORKDIR /app
COPY main.go .
RUN go build -o server main.go
EXPOSE 8080
CMD ["./server"]
```

3. Construye y verifica tamaño:
```bash
docker build -t app-pesada .
docker images app-pesada
```

4. Crea `Dockerfile.optimizado` CON multi-stage (bueno):
```dockerfile
# Etapa 1: Build
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o server main.go

# Etapa 2: Runtime
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/server .
EXPOSE 8080
USER 1000:1000
CMD ["./server"]
```

5. Construye y compara:
```bash
docker build -f Dockerfile.optimizado -t app-optimizada .
docker images | grep app-
```

**Verificación**: La imagen optimizada debería ser ~90% más pequeña

**Reto adicional**:
- Implementa health check
- Usa scratch como imagen final en lugar de alpine
- Agrega tests en una etapa intermedia

---

### Ejercicio 9: Seguridad y secrets

**Objetivo**: Implementar mejores prácticas de seguridad

**Pasos**:

1. Estructura del proyecto:
```bash
mkdir secure_app
cd secure_app
mkdir secrets
```

2. Crea secrets:
```bash
echo "super_secret_password" > secrets/db_password.txt
echo "api_key_12345" > secrets/api_key.txt
chmod 600 secrets/*
```

3. Crea `docker-compose.yml`:
```yaml
version: '3.8'

services:
  app:
    build: .
    secrets:
      - db_password
      - api_key
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
      - API_KEY_FILE=/run/secrets/api_key
    user: "1000:1000"
    read_only: true
    tmpfs:
      - /tmp
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    security_opt:
      - no-new-privileges:true

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    file: ./secrets/api_key.txt
```

4. Crea `Dockerfile`:
```dockerfile
FROM python:3.11-alpine

# Crear usuario no-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copiar requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY --chown=appuser:appgroup app.py .

USER appuser

CMD ["python", "app.py"]
```

5. Crea `app.py`:
```python
import os

def read_secret(secret_name):
    secret_path = os.environ.get(f'{secret_name.upper()}_FILE')
    if secret_path and os.path.exists(secret_path):
        with open(secret_path) as f:
            return f.read().strip()
    return None

db_password = read_secret('db_password')
api_key = read_secret('api_key')

print(f"DB Password: {'*' * len(db_password)}")
print(f"API Key: {api_key[:4]}...{api_key[-4:]}")
print("Aplicación iniciada de forma segura")
```

6. Crea `requirements.txt`:
```
# requirements.txt vacío o con dependencias necesarias
```

7. Inicia y verifica:
```bash
docker compose up --build
```

**Reto adicional**:
- Escanea vulnerabilidades con Trivy
- Implementa AppArmor o SELinux profile
- Usa Docker Content Trust

---

### Ejercicio 10: Stack completo de producción

**Objetivo**: Crear un entorno production-ready completo

**Pasos**:

Este ejercicio combina todo lo aprendido. Estructura completa:

```
proyecto_produccion/
├── docker-compose.yml
├── docker-compose.prod.yml
├── .env.example
├── services/
│   ├── web/
│   │   ├── Dockerfile
│   │   └── nginx.conf
│   ├── api/
│   │   ├── Dockerfile
│   │   └── src/
│   └── worker/
│       ├── Dockerfile
│       └── src/
├── config/
│   ├── postgres/
│   └── redis/
└── scripts/
    ├── backup.sh
    ├── restore.sh
    └── deploy.sh
```

1. Crea `docker-compose.yml` (base):
```yaml
version: '3.8'

services:
  nginx:
    build: ./services/web
    ports:
      - "${WEB_PORT:-80}:80"
    depends_on:
      api:
        condition: service_healthy
    networks:
      - frontend
    restart: unless-stopped

  api:
    build: ./services/api
    environment:
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASS}@db:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    networks:
      - frontend
      - backend
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped

  worker:
    build: ./services/worker
    environment:
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASS}@db:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    networks:
      - backend
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASS}
      - POSTGRES_DB=${DB_NAME}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./config/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./config/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    networks:
      - monitoring
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - monitoring
    depends_on:
      - prometheus
    restart: unless-stopped

networks:
  frontend:
  backend:
    internal: true
  monitoring:

volumes:
  postgres_data:
  redis_data:
  prometheus_data:
  grafana_data:
```

2. Crea `docker-compose.prod.yml`:
```yaml
version: '3.8'

services:
  nginx:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  api:
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  db:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
```

3. Crea `.env.example`:
```env
# Base de datos
DB_USER=usuario
DB_PASS=cambiar_en_produccion
DB_NAME=aplicacion

# Puertos
WEB_PORT=80

# Grafana
GRAFANA_PASSWORD=admin
```

4. Crea script de backup (`scripts/backup.sh`):
```bash
#!/bin/bash
set -e

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "Backing up database..."
docker compose exec -T db pg_dump -U $DB_USER $DB_NAME | gzip > "$BACKUP_DIR/db_${DATE}.sql.gz"

echo "Backing up volumes..."
docker run --rm \
  -v proyecto_produccion_postgres_data:/data \
  -v "$(pwd)/$BACKUP_DIR:/backup" \
  alpine tar czf "/backup/postgres_${DATE}.tar.gz" -C /data .

echo "Backup completed: $BACKUP_DIR"
```

5. Deploy:
```bash
# Copiar .env.example a .env y configurar
cp .env.example .env
nano .env

# Producción
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Ver logs
docker compose logs -f

# Verificar salud
docker compose ps
```

**Verificación**:
- Todos los servicios tienen status "healthy"
- Logs no muestran errores críticos
- Prometheus recopila métricas
- Grafana muestra dashboards

**Reto adicional**:
- Implementa CI/CD con GitHub Actions
- Agrega SSL/TLS con Let's Encrypt
- Implementa blue-green deployment
- Configura alertas en Prometheus

---

## ✅ Checklist de progreso

### Nivel Básico
- [ ] Ejercicio 1: Primer contenedor
- [ ] Ejercicio 2: Comandos interactivos
- [ ] Ejercicio 3: Primer docker-compose
- [ ] Ejercicio 4: Volúmenes persistentes

### Nivel Intermedio
- [ ] Ejercicio 5: Stack LAMP
- [ ] Ejercicio 6: Node.js hot reload
- [ ] Ejercicio 7: Redes y comunicación

### Nivel Avanzado
- [ ] Ejercicio 8: Multi-stage builds
- [ ] Ejercicio 9: Seguridad y secrets
- [ ] Ejercicio 10: Stack de producción

---

## 📚 Recursos adicionales

Después de completar estos ejercicios:

1. **Practica más**: Crea tus propios proyectos
2. **Lee documentación**: docs.docker.com
3. **Únete a comunidades**: Reddit, Discord, foros
4. **Certifícate**: Docker Certified Associate

---

**¡Felicidades por completar los ejercicios!** 🎉

Regresa al [README principal](README.md) para continuar tu aprendizaje.