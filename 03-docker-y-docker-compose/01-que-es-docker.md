# ¿Qué es Docker?

## Introducción

Docker es una plataforma de código abierto que permite desarrollar, distribuir y ejecutar aplicaciones dentro de **contenedores**. Piensa en Docker como un sistema que empaqueta tu aplicación junto con todo lo que necesita para funcionar (código, librerías, dependencias, configuraciones) en un paquete portable y ligero.

## ¿Por qué usar Docker?

### Problemas que resuelve

**"En mi máquina funciona"** - Este es uno de los problemas clásicos del desarrollo de software. Docker soluciona esto garantizando que tu aplicación funcione igual en cualquier lugar: tu ordenador, el servidor de producción, o la máquina de otro desarrollador.

### Ventajas principales

1. **Portabilidad**: Los contenedores funcionan igual en cualquier sistema operativo
2. **Aislamiento**: Cada aplicación corre en su propio entorno, sin conflictos
3. **Eficiencia**: Los contenedores son mucho más ligeros que las máquinas virtuales
4. **Escalabilidad**: Fácil de replicar y escalar aplicaciones
5. **Versionado**: Puedes tener diferentes versiones de la misma aplicación sin conflictos

## Conceptos Fundamentales

### 1. Contenedores

Un **contenedor** es una instancia en ejecución de una imagen. Es un proceso aislado que incluye:
- Tu aplicación
- Las librerías necesarias
- Las dependencias
- Configuraciones básicas del sistema

**Analogía**: Si una imagen es una receta de cocina, el contenedor es el plato cocinado.

**Características de los contenedores:**
- Son efímeros (se pueden crear y destruir fácilmente)
- Son ligeros (comparten el kernel del sistema operativo)
- Están aislados (no interfieren entre sí)
- Son portables (funcionan igual en cualquier lugar)

### 2. Imágenes

Una **imagen** es una plantilla de solo lectura que contiene las instrucciones para crear un contenedor. Incluye:
- Sistema operativo base (generalmente una versión mínima de Linux)
- Código de tu aplicación
- Dependencias y librerías
- Variables de entorno
- Comandos a ejecutar

**Analogía**: Una imagen es como un molde o plantilla. De una misma imagen puedes crear múltiples contenedores.

**Tipos de imágenes:**
- **Imágenes oficiales**: Mantenidas por Docker o las organizaciones oficiales (ej: `nginx`, `mysql`, `ubuntu`)
- **Imágenes de la comunidad**: Creadas por usuarios y compartidas en Docker Hub
- **Imágenes personalizadas**: Las que tú creas para tus proyectos específicos

### 3. Volúmenes

Los **volúmenes** son el mecanismo para persistir datos generados y utilizados por los contenedores.

**¿Por qué son necesarios?**
- Los contenedores son efímeros: cuando se destruyen, pierden todos sus datos
- Los volúmenes permiten guardar información importante fuera del contenedor
- Los datos en volúmenes persisten incluso después de eliminar el contenedor

**Tipos de almacenamiento en Docker:**

#### a) Volúmenes (Volumes)
```bash
# Crear un volumen
docker volume create mi_volumen

# Usar un volumen en un contenedor
docker run -v mi_volumen:/ruta/en/contenedor mi_imagen
```

**Ventajas:**
- Gestionados completamente por Docker
- Funcionan en todos los sistemas operativos
- Son la opción recomendada para persistir datos
- Fáciles de respaldar y migrar

#### b) Bind Mounts
```bash
# Montar una carpeta local en el contenedor
docker run -v /ruta/local:/ruta/en/contenedor mi_imagen
```

**Características:**
- Vinculan directamente una carpeta de tu sistema al contenedor
- Útiles para desarrollo (cambios en archivos se reflejan inmediatamente)
- Dependen de la estructura de carpetas de tu sistema

#### c) tmpfs (solo Linux)
- Almacenamiento temporal en memoria RAM
- Los datos se pierden al detener el contenedor
- Útil para datos sensibles o temporales

**Ejemplo práctico de volúmenes:**
```yaml
# En docker-compose.yml
services:
  base_datos:
    image: mysql:8.0
    volumes:
      - datos_mysql:/var/lib/mysql  # Los datos de MySQL persisten aquí

volumes:
  datos_mysql:  # Definición del volumen
```

### 4. Redes

Las **redes** en Docker permiten la comunicación entre contenedores y con el exterior.

**Tipos de redes:**

#### a) Bridge (puente) - Por defecto
- Red privada interna
- Los contenedores pueden comunicarse entre sí usando nombres
- Necesitan mapeo de puertos para acceso desde el host

```bash
# Crear una red bridge personalizada
docker network create mi_red
```

#### b) Host
- El contenedor usa directamente la red del host
- Sin aislamiento de red
- Mayor rendimiento pero menos seguro

#### c) None
- Sin conectividad de red
- Aislamiento total

**¿Cómo se comunican los contenedores?**

Dentro de la misma red Docker, los contenedores pueden comunicarse usando sus nombres:

```yaml
# docker-compose.yml
services:
  aplicacion:
    image: mi_app
    networks:
      - red_interna
    environment:
      - DB_HOST=base_datos  # ¡Usa el nombre del servicio!
  
  base_datos:
    image: mysql:8.0
    networks:
      - red_interna

networks:
  red_interna:
```

**Mapeo de puertos:**

Para acceder a un contenedor desde tu ordenador necesitas mapear puertos:

```bash
# Formato: puerto_host:puerto_contenedor
docker run -p 8080:80 nginx
```

Esto significa:
- El puerto 80 del contenedor (donde nginx escucha)
- Se expone en el puerto 8080 de tu ordenador
- Accedes en tu navegador: `http://localhost:8080`

## Docker vs Máquinas Virtuales

| Característica | Contenedor Docker | Máquina Virtual |
|----------------|-------------------|-----------------|
| **Tamaño** | Megabytes | Gigabytes |
| **Velocidad de inicio** | Segundos | Minutos |
| **Recursos** | Comparte kernel del host | SO completo por VM |
| **Aislamiento** | A nivel de proceso | Completo (hardware virtualizado) |
| **Portabilidad** | Alta | Media |

**Diagrama conceptual:**

```
Sistema Operativo Host
├── Docker Engine
    ├── Contenedor 1 (App A + Dependencias)
    ├── Contenedor 2 (App B + Dependencias)
    └── Contenedor 3 (App C + Dependencias)

vs

Sistema Operativo Host
├── Hypervisor
    ├── VM 1 (SO completo + App A)
    ├── VM 2 (SO completo + App B)
    └── VM 3 (SO completo + App C)
```

## Arquitectura de Docker

Docker usa una arquitectura cliente-servidor:

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────────┐
│   Cliente   │ ────────▶│  Docker Daemon   │ ────────▶│   Registry      │
│  (docker)   │         │   (dockerd)      │         │ (Docker Hub)    │
└─────────────┘         └──────────────────┘         └─────────────────┘
                                │
                                ▼
                        ┌────────────────┐
                        │  Contenedores  │
                        │   Imágenes     │
                        │   Volúmenes    │
                        │    Redes       │
                        └────────────────┘
```

**Componentes:**

1. **Docker Client (docker)**: La interfaz de línea de comandos que usas
2. **Docker Daemon (dockerd)**: El servicio que gestiona los contenedores
3. **Docker Registry**: Repositorio de imágenes (por defecto Docker Hub)

## Flujo de trabajo básico

```
1. Descargar imagen
   docker pull nginx:latest
   
2. Crear y ejecutar contenedor
   docker run -d -p 8080:80 --name mi_servidor nginx:latest
   
3. Ver contenedores en ejecución
   docker ps
   
4. Detener contenedor
   docker stop mi_servidor
   
5. Eliminar contenedor
   docker rm mi_servidor
```

## Ciclo de vida de un contenedor

```
┌─────────┐
│ CREATED │  (contenedor creado pero no iniciado)
└────┬────┘
     │ docker start
     ▼
┌─────────┐
│ RUNNING │  (contenedor en ejecución)
└────┬────┘
     │ docker stop / docker pause
     ▼
┌─────────┐
│ STOPPED │  (contenedor detenido, datos conservados)
│ PAUSED  │
└────┬────┘
     │ docker rm
     ▼
┌─────────┐
│ REMOVED │  (contenedor eliminado)
└─────────┘
```

## Dockerfile: Creando tus propias imágenes

Un **Dockerfile** es un archivo de texto con instrucciones para construir una imagen personalizada.

**Ejemplo básico:**

```dockerfile
# Imagen base
FROM ubuntu:22.04

# Información del mantenedor
LABEL maintainer="tu@email.com"

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# Copiar archivos de tu proyecto
COPY . /app

# Establecer directorio de trabajo
WORKDIR /app

# Instalar dependencias de Python
RUN pip3 install -r requirements.txt

# Puerto que expone la aplicación
EXPOSE 5000

# Comando a ejecutar cuando inicie el contenedor
CMD ["python3", "app.py"]
```

**Instrucciones principales:**

- `FROM`: Imagen base para tu contenedor
- `RUN`: Ejecuta comandos durante la construcción
- `COPY`: Copia archivos de tu ordenador a la imagen
- `WORKDIR`: Establece el directorio de trabajo
- `EXPOSE`: Documenta qué puerto usa la aplicación
- `CMD`: Comando por defecto al iniciar el contenedor
- `ENV`: Define variables de entorno

**Construir la imagen:**

```bash
docker build -t mi_aplicacion:v1.0 .
```

## Registry y Docker Hub

**Docker Hub** es el registro público de imágenes Docker, como GitHub pero para imágenes.

**Acciones comunes:**

```bash
# Buscar imágenes
docker search nginx

# Descargar imagen
docker pull nginx:latest

# Subir tu imagen (requiere cuenta)
docker login
docker tag mi_aplicacion:v1.0 usuario/mi_aplicacion:v1.0
docker push usuario/mi_aplicacion:v1.0
```

## Resumen de conceptos clave

| Concepto | ¿Qué es? | Ejemplo |
|----------|----------|---------|
| **Imagen** | Plantilla inmutable | `nginx:latest`, `mysql:8.0` |
| **Contenedor** | Instancia ejecutándose | Tu servidor web corriendo |
| **Volumen** | Almacenamiento persistente | Base de datos que no pierde datos |
| **Red** | Comunicación entre contenedores | App que habla con base de datos |
| **Dockerfile** | Receta para crear imagen | Instrucciones para tu app |
| **Docker Compose** | Orquestador de múltiples contenedores | App completa con BD, cache, etc. |

## Próximos pasos

Ahora que entiendes los conceptos fundamentales, en los siguientes documentos aprenderás:

1. ✅ **Conceptos básicos** (este documento)
2. ⏭️ **¿Qué es Docker Compose?** - Gestionar múltiples contenedores
3. ⏭️ **Instalación** - Preparar tu sistema
4. ⏭️ **Comandos básicos** - Trabajar con Docker día a día
5. ⏭️ **Mejores prácticas** - Optimización y seguridad

---

**💡 Consejo**: No te preocupes si no entiendes todo perfectamente al principio. Docker se aprende practicando. ¡Vamos al siguiente documento!