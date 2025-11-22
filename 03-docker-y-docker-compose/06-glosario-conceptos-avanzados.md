# Glosario y Conceptos Complementarios

## Glosario de términos Docker

### A

**Alpine Linux**
Distribución Linux extremadamente ligera (~5MB) basada en musl libc y BusyBox. Es la base preferida para imágenes Docker por su tamaño reducido.

**API (Application Programming Interface)**
Interfaz que Docker expone para que otras aplicaciones puedan interactuar con el Docker Engine.

**ARG**
Instrucción de Dockerfile que define variables disponibles durante el build pero no en runtime.

### B

**Base Image**
La imagen FROM de la cual parte tu Dockerfile. Ejemplo: `FROM ubuntu:22.04`

**Bind Mount**
Montaje directo de una carpeta del host en un contenedor. Útil para desarrollo.

**Bridge Network**
Red virtual que permite la comunicación entre contenedores en el mismo host.

**Build Context**
Conjunto de archivos disponibles durante el `docker build`. Definido por el path en el comando build.

**BuildKit**
Motor de build moderno y más eficiente que reemplaza al builder tradicional de Docker.

### C

**Cache**
Sistema de Docker que reutiliza capas de builds anteriores para acelerar construcciones.

**cgroup (Control Group)**
Característica del kernel Linux que limita y aísla el uso de recursos de procesos.

**CMD**
Instrucción de Dockerfile que define el comando por defecto al iniciar el contenedor.

**Container**
Instancia ejecutable de una imagen Docker. Es efímero y aislado.

**Container Registry**
Repositorio para almacenar y distribuir imágenes Docker (ej: Docker Hub, AWS ECR).

**COPY**
Instrucción de Dockerfile para copiar archivos del build context a la imagen.

### D

**Daemon**
Proceso en segundo plano (dockerd) que gestiona objetos Docker como contenedores, imágenes, redes y volúmenes.

**Dangling Image**
Imagen sin tag, generalmente resultado de builds que crearon nuevas versiones.

**Detached Mode (-d)**
Ejecutar contenedores en segundo plano sin bloquear la terminal.

**Docker Compose**
Herramienta para definir y ejecutar aplicaciones Docker multi-contenedor usando archivos YAML.

**Docker Hub**
Registro público de imágenes Docker mantenido por Docker Inc.

**Dockerfile**
Archivo de texto con instrucciones para construir una imagen Docker.

**Docker Scout**
Herramienta de análisis de seguridad para identificar vulnerabilidades en imágenes.

### E

**ENTRYPOINT**
Instrucción de Dockerfile que define el ejecutable principal del contenedor.

**ENV**
Instrucción de Dockerfile para establecer variables de entorno.

**Ephemeral**
Característica de los contenedores: son temporales y pueden destruirse sin perder datos críticos (si se usan volúmenes correctamente).

**EXPOSE**
Instrucción de Dockerfile que documenta qué puertos usa la aplicación (no los publica automáticamente).

### F

**FROM**
Primera instrucción obligatoria en un Dockerfile que especifica la imagen base.

### H

**Health Check**
Comando que Docker ejecuta periódicamente para verificar que el contenedor está funcionando correctamente.

**Host Network**
Modo de red donde el contenedor comparte directamente la red del host.

### I

**Image**
Plantilla inmutable de solo lectura que contiene el sistema operativo, aplicación y dependencias necesarias para crear contenedores.

**Image Layer**
Cada instrucción en un Dockerfile crea una capa. Las imágenes son la suma de estas capas apiladas.

**Isolation**
Aislamiento de recursos y procesos que Docker proporciona a cada contenedor.

### L

**Layer**
Cada modificación al filesystem durante el build de una imagen. Las capas se apilan y son de solo lectura.

**LABEL**
Instrucción de Dockerfile para agregar metadata a la imagen.

### M

**Multi-stage Build**
Técnica de Dockerfile que usa múltiples FROM para crear builds optimizados con menor tamaño.

**Mount**
Acción de vincular almacenamiento del host o volúmenes al filesystem del contenedor.

### N

**Namespace**
Característica del kernel Linux que aísla recursos del sistema para cada contenedor.

**Network Driver**
Plugin que define cómo los contenedores se comunican. Tipos: bridge, host, overlay, macvlan.

**Node**
Máquina física o virtual que ejecuta Docker Engine.

### O

**Orchestration**
Gestión automatizada de múltiples contenedores en múltiples hosts (ej: Kubernetes, Docker Swarm).

**Overlay Network**
Red que permite comunicación entre contenedores en diferentes hosts Docker.

### P

**Port Mapping**
Vincular un puerto del host a un puerto del contenedor para acceso externo.

**Privileged Container**
Contenedor que tiene acceso casi completo al host. Raramente recomendado por seguridad.

**Prune**
Comando para limpiar recursos no utilizados (contenedores, imágenes, volúmenes, redes).

### R

**Registry**
Servidor que almacena imágenes Docker. Puede ser público (Docker Hub) o privado.

**Repository**
Colección de imágenes relacionadas, generalmente diferentes versiones del mismo software.

**Restart Policy**
Configuración que determina si y cuándo Docker reinicia un contenedor automáticamente.

**RUN**
Instrucción de Dockerfile que ejecuta comandos durante el build de la imagen.

**Runtime**
Software responsable de ejecutar contenedores (ej: containerd, runc).

### S

**Service**
En Docker Compose: definición de un contenedor y su configuración.
En Docker Swarm: tarea que se ejecuta en el cluster.

**Socket**
Archivo Unix socket (/var/run/docker.sock) usado para comunicación con el Docker daemon.

**Swarm**
Herramienta nativa de Docker para orquestación y clustering.

### T

**Tag**
Etiqueta que identifica versiones específicas de una imagen (ej: nginx:alpine, nginx:1.25).

**tmpfs**
Sistema de archivos temporal montado en memoria RAM del contenedor.

### U

**USER**
Instrucción de Dockerfile que especifica qué usuario ejecutará los comandos siguientes.

**Union File System**
Sistema que permite apilar múltiples directorios en uno solo. Base del sistema de layers de Docker.

### V

**Volume**
Mecanismo para persistir datos generados y usados por contenedores.

**Volume Driver**
Plugin que determina cómo y dónde se almacenan los volúmenes.

### W

**WORKDIR**
Instrucción de Dockerfile que establece el directorio de trabajo para las instrucciones siguientes.

---

## Conceptos avanzados complementarios

### Container Orchestration

**¿Qué es?**
Sistema para gestionar, escalar y mantener contenedores en producción a gran escala.

**Herramientas principales:**

1. **Kubernetes (K8s)**
   - Estándar de la industria
   - Complejo pero muy potente
   - Para producción a gran escala

2. **Docker Swarm**
   - Nativo de Docker
   - Más simple que Kubernetes
   - Para clusters pequeños a medianos

3. **Amazon ECS/EKS**
   - Servicios gestionados de AWS
   - ECS: Simple y específico de AWS
   - EKS: Kubernetes gestionado

**Cuándo necesitas orquestación:**
- Más de 10-20 contenedores en producción
- Múltiples hosts
- Necesitas auto-scaling
- Requieres alta disponibilidad

### Container Runtimes

Docker usa varios componentes bajo el capó:

```
Docker CLI
    ↓
Docker Daemon (dockerd)
    ↓
containerd (gestor de contenedores)
    ↓
runc (runtime de bajo nivel)
    ↓
Kernel Linux (namespaces, cgroups)
```

**Runtimes alternativos:**
- **containerd**: Puede usarse directamente sin Docker
- **CRI-O**: Runtime específico para Kubernetes
- **Podman**: Alternativa a Docker sin daemon

### Rootless Docker

Docker ejecutándose sin privilegios de root:

**Ventajas:**
- Mayor seguridad
- No requiere acceso root
- Aislamiento mejorado

**Limitaciones:**
- No todos los drivers de storage funcionan
- Networking más limitado
- Menos performance en algunos casos

**Instalación:**
```bash
dockerd-rootless-setuptool.sh install
```

### Docker in Docker (DinD)

Ejecutar Docker dentro de un contenedor Docker:

```yaml
services:
  docker:
    image: docker:dind
    privileged: true
    volumes:
      - docker-data:/var/lib/docker
```

**Usos:**
- CI/CD pipelines
- Entornos de testing aislados
- Desarrollo de herramientas Docker

**Advertencias:**
- Requiere modo privileged (riesgo de seguridad)
- Mayor complejidad
- Alternativas: Kaniko, BuildKit standalone

### Image Registries privados

**Docker Registry (oficial):**
```yaml
services:
  registry:
    image: registry:2
    ports:
      - 5000:5000
    volumes:
      - registry-data:/var/lib/registry
```

**Harbor (enterprise):**
- Gestión de usuarios y permisos
- Escaneo de vulnerabilidades integrado
- Replicación entre registries
- UI web completa

**Alternativas:**
- GitLab Container Registry
- AWS ECR
- Google Container Registry
- Azure Container Registry

### Service Mesh

Para aplicaciones distribuidas complejas:

**Istio:**
- Control de tráfico avanzado
- Seguridad (mTLS automático)
- Observabilidad mejorada

**Linkerd:**
- Más ligero que Istio
- Más simple de configurar
- Buen rendimiento

**Cuándo usar:**
- Microservicios complejos (10+ servicios)
- Necesitas tráfico avanzado (canary, blue-green)
- Requieres seguridad entre servicios

### Serverless Containers

Ejecutar contenedores sin gestionar servidores:

**AWS Fargate:**
```yaml
task_definition:
  family: mi-app
  containerDefinitions:
    - name: web
      image: mi-app:latest
      memory: 512
      cpu: 256
```

**Google Cloud Run:**
- Auto-scaling a cero
- Pago por uso real
- HTTPS automático

**Azure Container Instances:**
- Deploy rápido
- Sin gestión de VMs
- Integración con Azure

### Windows Containers

Docker también soporta contenedores Windows:

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022
COPY app.exe C:\\app\\
CMD ["C:\\app\\app.exe"]
```

**Limitaciones:**
- Solo en Windows Server
- Imágenes más pesadas
- Menos maduro que Linux

### Docker Extensions

Sistema de plugins para Docker Desktop:

**Populares:**
- Lens: Gestión de Kubernetes
- Portainer: UI para Docker
- Snyk: Escaneo de seguridad
- Disk Usage: Análisis de espacio

### BuildKit avanzado

Características modernas de build:

**SSH mount para git privado:**
```dockerfile
FROM alpine
RUN --mount=type=ssh \
    git clone git@github.com:user/private-repo.git
```

**Secrets en build:**
```dockerfile
RUN --mount=type=secret,id=token \
    curl -H "Authorization: Bearer $(cat /run/secrets/token)" api.com
```

**Cache mounts:**
```dockerfile
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
```

---

## Patrones de diseño comunes

### Sidecar Pattern

Contenedor auxiliar que complementa al principal:

```yaml
services:
  app:
    image: mi-app
    
  log-collector:  # Sidecar
    image: fluentd
    volumes:
      - shared-logs:/logs
```

**Usos:**
- Logging
- Monitoring
- Service mesh proxies

### Ambassador Pattern

Proxy que intermedia comunicación:

```yaml
services:
  app:
    image: mi-app
    
  ambassador:  # Proxy
    image: nginx
    depends_on:
      - app
```

**Usos:**
- Load balancing
- Circuit breaking
- Retry logic

### Adapter Pattern

Contenedor que normaliza interfaces:

```yaml
services:
  legacy-app:
    image: old-app
    
  adapter:  # Normaliza API
    image: api-adapter
    depends_on:
      - legacy-app
```

---

## Debugging avanzado

### Acceder a contenedor sin shell

```bash
# Si el contenedor no tiene bash/sh
docker export contenedor | tar -C /tmp/contenedor -xvf -
```

### Ver syscalls

```bash
docker run --rm -it \
  --cap-add SYS_PTRACE \
  alpine strace ls
```

### Perfilar performance

```bash
# CPU profiling
docker stats --no-stream contenedor

# Memory profiling  
docker exec contenedor ps aux --sort=-%mem

# Disk I/O
docker exec contenedor iotop -o
```

### Network debugging

```bash
# Capturar tráfico
docker exec contenedor tcpdump -i any -w /tmp/capture.pcap

# Ver conexiones
docker exec contenedor netstat -tulpn

# DNS debugging
docker exec contenedor nslookup google.com
```

---

## Recursos de aprendizaje adicionales

### Cursos Online
- Docker Mastery (Udemy - Bret Fisher)
- Play with Docker (labs.play-with-docker.com)
- Katacoda Docker Scenarios

### Libros
- "Docker Deep Dive" por Nigel Poulton
- "Docker in Practice" por Ian Miell
- "Kubernetes Patterns" por Bilgin Ibryam

### Certificaciones
- Docker Certified Associate (DCA)
- Certified Kubernetes Administrator (CKA)
- Certified Kubernetes Application Developer (CKAD)

### Laboratorios prácticos
- **Killercoda**: Escenarios interactivos
- **Play with Docker**: Entorno temporal gratis
- **Katacoda**: Tutoriales paso a paso

### Comunidad
- DockerCon (conferencia anual)
- Meetups locales de Docker
- Slack: dockercommunity.slack.com
- Discord: Docker Community

---

## Comparativa: Docker vs alternativas

### Docker vs Podman

| Característica | Docker | Podman |
|----------------|--------|--------|
| Daemon | Sí (dockerd) | No (daemonless) |
| Root | Necesita privilegios | Rootless nativo |
| Docker Compose | Sí | Compatible |
| Compatibilidad | Estándar | Compatible con Docker |
| Adopción | Muy alta | Creciendo |

### Docker vs LXC/LXD

| Característica | Docker | LXC/LXD |
|----------------|--------|---------|
| Foco | Aplicaciones | Sistemas completos |
| Tamaño | Ligero | Más pesado |
| Portabilidad | Alta | Media |
| Ecosistema | Enorme | Limitado |

### Docker vs VMs

Ya cubierto en detalle en el documento 1, pero resumiendo:

**Usa Docker cuando:**
- Necesitas portabilidad
- Quieres arranque rápido
- Recursos limitados
- Despliegues frecuentes

**Usa VMs cuando:**
- Necesitas aislamiento total
- Diferentes sistemas operativos
- Compatibilidad legacy
- Requisitos de cumplimiento estrictos

---

## Tendencias futuras

### WebAssembly (Wasm)

Posible futuro complemento/alternativa:

**Ventajas sobre contenedores:**
- Más ligero (KB vs MB)
- Arranque instantáneo (ms vs segundos)
- Mayor seguridad (sandbox fuerte)
- Portabilidad universal

**Estado actual:**
- Experimental en Docker
- WasmEdge runtime disponible
- Kubernetes soporta Wasm

### Confidential Computing

Contenedores con datos encriptados en memoria:

- Intel SGX
- AMD SEV
- Confidential VMs

### Edge Computing

Docker en dispositivos IoT y edge:

- Docker para ARM
- K3s (Kubernetes ligero)
- MicroK8s

---

## Conclusión del glosario

Este glosario complementa los documentos principales con:
- ✅ Terminología técnica explicada
- ✅ Conceptos avanzados introductorios
- ✅ Recursos para profundizar
- ✅ Tendencias y futuro

**Recomendación**: No intentes memorizar todo. Usa este documento como referencia cuando encuentres términos desconocidos.

---

**Regresa al [README principal](README.md) para continuar tu aprendizaje** 📚