# ⚡ Inicio Rápido - Docker en 10 minutos

## 🎯 ¿Tienes prisa? Empieza aquí

Esta guía te permite empezar con Docker en menos de 10 minutos si ya tienes Ubuntu Server instalado.

---

## Paso 1: Instalar Docker (3 minutos)

```bash
# Actualizar sistema
sudo apt update

# Instalar dependencias
sudo apt install -y ca-certificates curl gnupg lsb-release

# Agregar clave GPG de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Agregar repositorio
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verificar instalación
docker --version
docker compose version
```

---

## Paso 2: Configurar usuario (1 minuto)

```bash
# Agregar tu usuario al grupo docker
sudo usermod -aG docker $USER

# Activar cambios
newgrp docker

# Probar sin sudo
docker run hello-world
```

---

## Paso 3: Tu primera aplicación (5 minutos)

### Ejemplo 1: Servidor web simple

```bash
# Crear directorio
mkdir mi_primer_proyecto
cd mi_primer_proyecto

# Crear docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
EOF

# Crear contenido HTML
mkdir html
cat > html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>¡Docker funciona!</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            text-align: center;
        }
        h1 { color: #0066cc; }
    </style>
</head>
<body>
    <h1>🐳 ¡Tu primer contenedor Docker!</h1>
    <p>Si ves esto, Docker está funcionando correctamente.</p>
</body>
</html>
EOF

# Iniciar
docker compose up -d

# Abrir en navegador: http://tu_ip:8080
```

### Ejemplo 2: Aplicación con base de datos

```bash
# Crear nuevo proyecto
mkdir app_con_bd
cd app_con_bd

# Crear docker-compose.yml
cat > docker-compose.yml << 'EOF'
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
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: miapp
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
    depends_on:
      - db

volumes:
  mysql_data:
EOF

# Crear aplicación PHP
mkdir www
cat > www/index.php << 'EOF'
<?php
$host = 'db';
$user = 'usuario';
$pass = 'password';
$db = 'miapp';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    echo "<h1>✅ Conectado a MySQL</h1>";
    echo "<p>Todo funciona correctamente</p>";
    echo "<p><a href='http://localhost:8080'>Ir a phpMyAdmin</a></p>";
} catch(PDOException $e) {
    echo "<h1>❌ Error</h1>";
    echo "<p>" . $e->getMessage() . "</p>";
}
?>
EOF

# Iniciar
docker compose up -d

# Acceder a:
# - Aplicación: http://tu_ip
# - phpMyAdmin: http://tu_ip:8080
```

---

## 🎓 Comandos esenciales que debes conocer

### Gestión de servicios
```bash
# Iniciar servicios
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs -f

# Detener servicios
docker compose down

# Reiniciar un servicio
docker compose restart web
```

### Gestión de contenedores
```bash
# Ver contenedores activos
docker ps

# Ver todos los contenedores
docker ps -a

# Detener contenedor
docker stop nombre_contenedor

# Eliminar contenedor
docker rm nombre_contenedor

# Ejecutar comando en contenedor
docker exec -it nombre_contenedor bash
```

### Limpieza
```bash
# Limpiar todo lo no usado
docker system prune

# Limpiar incluyendo volúmenes
docker system prune -a --volumes

# Ver espacio usado
docker system df
```

---

## 🚨 Solución rápida de problemas

### "Cannot connect to Docker daemon"
```bash
# Iniciar Docker
sudo systemctl start docker

# Habilitar inicio automático
sudo systemctl enable docker
```

### "Permission denied"
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Cerrar sesión y volver a entrar
exit
```

### Puerto ya en uso
```bash
# Ver qué usa el puerto
sudo lsof -i :80

# Cambiar el puerto en docker-compose.yml
ports:
  - "8888:80"  # Usar 8888 en lugar de 80
```

### Contenedor no inicia
```bash
# Ver logs
docker compose logs nombre_servicio

# Ver todos los logs
docker compose logs
```

---

## 📚 ¿Qué hacer después?

### Has completado el inicio rápido, ahora:

1. **Lee la documentación completa** → [README.md](README.md)
2. **Aprende los fundamentos** → [01-que-es-docker.md](01-que-es-docker.md)
3. **Practica con ejercicios** → [EJERCICIOS-PRACTICOS.md](EJERCICIOS-PRACTICOS.md)

### Proyectos sugeridos para practicar:

- [ ] Blog con WordPress
- [ ] API con Node.js + PostgreSQL
- [ ] Aplicación Laravel
- [ ] Stack de monitoreo

---

## 🎯 Checklist de verificación

Marca lo que ya has logrado:

- [ ] Docker instalado y funcionando
- [ ] Ejecuté hello-world exitosamente
- [ ] Puedo usar Docker sin sudo
- [ ] Inicié mi primer contenedor nginx
- [ ] Creé mi primer docker-compose.yml
- [ ] Entiendo los comandos básicos
- [ ] Sé cómo ver logs
- [ ] Sé cómo detener servicios

---

## 💡 Tips finales

### Atajos útiles
```bash
# Agregar a ~/.bashrc
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dps='docker ps'
```

Recargar:
```bash
source ~/.bashrc
```

### Estructura recomendada para proyectos
```
mi_proyecto/
├── docker-compose.yml
├── .env
├── .dockerignore
├── services/
│   ├── web/
│   └── api/
└── config/
```

---

## 🚀 ¡Listo para empezar!

Tienes lo básico para trabajar con Docker. Ahora:

1. **Practica** estos ejemplos
2. **Modifícalos** para experimentar
3. **Lee** la documentación completa cuando estés listo

**Siguiente paso recomendado**: [README.md](README.md) para la guía completa.

---

**¡Feliz Dockerización!** 🐳

*Tiempo estimado para completar esta guía: 10 minutos*