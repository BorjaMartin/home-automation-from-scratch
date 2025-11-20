# Documentación Docker y Docker Compose para Principiantes

## 📚 Sobre esta documentación

Esta es una guía completa de **Docker y Docker Compose** diseñada para principiantes que quieren aprender desde cero. La documentación cubre desde los conceptos básicos hasta las mejores prácticas profesionales.

**Nivel**: Principiante a Intermedio  
**Tiempo estimado**: 4-6 horas de lectura  
**Objetivo**: Establecer bases sólidas para trabajar con contenedores Docker

---

## 📖 Índice de contenidos

### 1. [¿Qué es Docker?](01-que-es-docker.md)
Introducción a Docker y conceptos fundamentales:
- ¿Qué es Docker y por qué usarlo?
- Contenedores vs Máquinas Virtuales
- **Conceptos clave:**
  - Imágenes
  - Contenedores
  - Volúmenes
  - Redes
- Arquitectura de Docker
- Dockerfile básico
- Docker Registry y Docker Hub

**⏱️ Tiempo estimado**: 45 minutos

---

### 2. [¿Qué es Docker Compose?](02-que-es-docker-compose.md)
Gestión de aplicaciones multi-contenedor:
- Introducción a Docker Compose
- Problemas que resuelve
- Archivo `docker-compose.yml`
- Ventajas vs Docker CLI
- Casos de uso comunes
- Ejemplos prácticos (WordPress, Node.js, etc.)

**⏱️ Tiempo estimado**: 40 minutos

---

### 3. [Instalación de Docker y Docker Compose](03-instalacion-docker-compose.md)
Guía completa de instalación en Ubuntu Server:
- Requisitos previos
- Instalación paso a paso (método oficial)
- Configuración post-instalación
- Permisos de usuario
- Verificación de instalación
- Configuración de firewall
- Solución de problemas comunes
- Comandos de diagnóstico

**⏱️ Tiempo estimado**: 30 minutos + tiempo de instalación

---

### 4. [Comandos Básicos](04-comandos-basicos.md)
Referencia completa de comandos esenciales:
- **Docker CLI:**
  - Gestión de contenedores (`run`, `ps`, `stop`, `rm`, etc.)
  - Gestión de imágenes (`pull`, `build`, `push`, etc.)
  - Logs y debugging
  - Inspección y estadísticas
- **Docker Compose:**
  - Gestión de servicios (`up`, `down`, `restart`, etc.)
  - Logs y debugging
  - Construcción de imágenes
  - Validación de configuración
- **Gestión de recursos:**
  - Volúmenes
  - Redes
  - Limpieza del sistema
- Atajos y alias útiles

**⏱️ Tiempo estimado**: 1-1.5 horas

---

### 5. [Mejores Prácticas](05-mejores-practicas.md)
Guía profesional de optimización y seguridad:
- **Organización de proyectos:**
  - Estructura de directorios
  - Separación de entornos
  - Gestión de variables de entorno
  - Uso de `.dockerignore`
- **Dockerfiles eficientes:**
  - Optimización de capas
  - Multi-stage builds
  - Cache de dependencias
  - Imágenes ligeras
- **Docker Compose avanzado:**
  - Naming conventions
  - Healthchecks
  - Límites de recursos
  - Redes segmentadas
- **Seguridad:**
  - Usuarios no-root
  - Secrets
  - Escaneo de vulnerabilidades
  - Principio de mínimo privilegio
- **Performance:**
  - BuildKit
  - Optimización de imágenes
  - Logging eficiente
- **DevOps:**
  - Desarrollo vs Producción
  - Monitoreo y observabilidad
  - Backup y recuperación
  - CI/CD
- **Troubleshooting:**
  - Problemas comunes
  - Herramientas de diagnóstico

**⏱️ Tiempo estimado**: 2 horas

---

## 🚀 Cómo usar esta documentación

### Para principiantes absolutos
Si nunca has usado Docker:

1. **Empieza aquí**: Lee [01-que-es-docker.md](01-que-es-docker.md) completo
2. **Continúa con**: [02-que-es-docker-compose.md](02-que-es-docker-compose.md)
3. **Instala**: Sigue [03-instalacion-docker-compose.md](03-instalacion-docker-compose.md)
4. **Practica**: Ejecuta los ejemplos del documento 2
5. **Aprende comandos**: Usa [04-comandos-basicos.md](04-comandos-basicos.md) como referencia
6. **Mejora**: Lee [05-mejores-practicas.md](05-mejores-practicas.md)

### Para desarrolladores con experiencia básica
Si ya conoces Docker pero quieres profundizar:

1. **Repaso rápido**: Ojea el documento 1 y 2
2. **Comandos**: Revisa [04-comandos-basicos.md](04-comandos-basicos.md) para completar conocimientos
3. **Profundiza**: Enfócate en [05-mejores-practicas.md](05-mejores-practicas.md)
4. **Aplica**: Implementa las mejores prácticas en tus proyectos

### Como referencia
Estos documentos están diseñados para ser referencia continua:

- **Olvidaste un comando?** → Documento 4
- **Problemas de instalación?** → Documento 3
- **Necesitas optimizar?** → Documento 5
- **Dudas conceptuales?** → Documentos 1 y 2

---

## 🎯 Objetivos de aprendizaje

Al completar esta documentación, serás capaz de:

### Nivel Básico
- ✅ Explicar qué es Docker y por qué se usa
- ✅ Entender la diferencia entre imágenes y contenedores
- ✅ Instalar Docker y Docker Compose correctamente
- ✅ Ejecutar contenedores básicos
- ✅ Usar comandos esenciales de Docker

### Nivel Intermedio
- ✅ Crear y gestionar aplicaciones multi-contenedor
- ✅ Escribir archivos `docker-compose.yml` funcionales
- ✅ Gestionar volúmenes y redes
- ✅ Debuggear problemas comunes
- ✅ Implementar healthchecks

### Nivel Avanzado
- ✅ Escribir Dockerfiles optimizados
- ✅ Implementar multi-stage builds
- ✅ Aplicar mejores prácticas de seguridad
- ✅ Configurar entornos de desarrollo y producción
- ✅ Implementar backup y monitoreo
- ✅ Integrar Docker en CI/CD

---

## 💡 Recomendaciones de estudio

### Aprende haciendo
- **No solo leas**: Ejecuta los ejemplos mientras lees
- **Experimenta**: Modifica los ejemplos y observa qué pasa
- **Crea proyectos**: Aplica lo aprendido en proyectos reales

### Orden sugerido de práctica
1. **Día 1**: Conceptos + Instalación
   - Lee documentos 1, 2 y 3
   - Instala Docker
   - Ejecuta el ejemplo de WordPress del documento 2

2. **Día 2**: Comandos básicos
   - Lee documento 4
   - Practica comandos en tu instalación
   - Crea tu primer `docker-compose.yml` simple

3. **Día 3**: Mejores prácticas
   - Lee documento 5
   - Aplica optimizaciones a tus ejemplos
   - Implementa seguridad básica

4. **Días siguientes**: Proyecto real
   - Elige una aplicación para dockerizar
   - Aplica todo lo aprendido
   - Consulta la documentación como referencia

### Recursos de práctica
- Dockeriza tu proyecto personal
- Clona un repositorio y crea su `docker-compose.yml`
- Participa en retos de Docker
- Contribuye a proyectos open source

---

## 📝 Notas importantes

### Sobre las versiones
Esta documentación usa:
- **Docker Engine**: Última versión estable
- **Docker Compose**: V2 (integrado en Docker CLI)
- **Ubuntu Server**: 20.04 LTS o superior

Los comandos y conceptos son aplicables a versiones recientes.

### Sobre los ejemplos
- Todos los ejemplos son funcionales y probados
- Puedes copiar y pegar directamente
- Adapta rutas y nombres según tu caso
- Los ejemplos priorizan claridad sobre brevedad

### Sobre la seguridad
- Los ejemplos usan contraseñas simples para claridad
- **Nunca uses contraseñas simples en producción**
- Sigue las recomendaciones de seguridad del documento 5

---

## 🔧 Requisitos previos

### Conocimientos necesarios
- **Básicos**:
  - Uso de terminal Linux
  - Conceptos básicos de redes (IP, puertos)
  - Edición de archivos de texto

- **Recomendados** (pero no obligatorios):
  - Conocimientos de YAML
  - Experiencia con aplicaciones web
  - Familiaridad con Git

### Hardware requerido
- **Mínimo**:
  - 2 GB RAM
  - 10 GB espacio en disco
  - Procesador de 64 bits

- **Recomendado**:
  - 4+ GB RAM
  - 20+ GB espacio en disco
  - Múltiples cores

---

## 🆘 Soporte y ayuda

### Si tienes problemas

1. **Revisa troubleshooting**: Documento 5 tiene una sección completa
2. **Consulta logs**: Usa `docker logs` o `docker compose logs`
3. **Verifica configuración**: Usa `docker compose config`
4. **Busca en documentación oficial**: [docs.docker.com](https://docs.docker.com)

### Recursos adicionales
- [Documentación oficial de Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Stack Overflow - Docker](https://stackoverflow.com/questions/tagged/docker)
- [Reddit r/docker](https://www.reddit.com/r/docker/)
- [Awesome Docker](https://github.com/veggiemonk/awesome-docker)

---

## 📋 Checklist de progreso

Marca tu avance:

### Conceptos básicos
- [ ] Entiendo qué es un contenedor
- [ ] Entiendo qué es una imagen
- [ ] Sé la diferencia entre contenedores y VMs
- [ ] Entiendo volúmenes y su propósito
- [ ] Entiendo redes en Docker

### Instalación
- [ ] Docker instalado correctamente
- [ ] Docker Compose instalado
- [ ] Puedo ejecutar Docker sin sudo
- [ ] Docker se inicia al arranque
- [ ] Probé el contenedor hello-world

### Práctica básica
- [ ] Ejecuté mi primer contenedor
- [ ] Creé mi primer docker-compose.yml
- [ ] Inicié una aplicación multi-contenedor
- [ ] Consulté logs de contenedores
- [ ] Ejecuté comandos dentro de contenedores

### Nivel intermedio
- [ ] Creé un Dockerfile personalizado
- [ ] Gestioné volúmenes persistentes
- [ ] Configuré redes personalizadas
- [ ] Implementé healthchecks
- [ ] Separé entornos dev/prod

### Nivel avanzado
- [ ] Implementé multi-stage builds
- [ ] Optimicé tamaño de imágenes
- [ ] Apliqué mejores prácticas de seguridad
- [ ] Configuré backup automático
- [ ] Integré Docker en CI/CD

---

## 🎓 Certificación de conocimientos

Has dominado Docker cuando puedes:

1. **Explicar** a otra persona qué es Docker y por qué usarlo
2. **Crear** una aplicación multi-contenedor desde cero
3. **Debuggear** problemas comunes sin ayuda
4. **Optimizar** Dockerfiles para producción
5. **Implementar** seguridad y mejores prácticas

---

## 🔄 Mantenimiento de esta documentación

Esta documentación es un documento vivo:
- Se actualiza con nuevas versiones de Docker
- Se agregan ejemplos según feedback
- Se corrigen errores reportados
- Se expanden secciones según necesidad

**Última actualización**: Noviembre 2024

---

## 📄 Licencia y uso

Esta documentación es de uso libre para:
- ✅ Aprendizaje personal
- ✅ Uso en empresas
- ✅ Enseñanza y formación
- ✅ Distribución con atribución

---

## 🚦 Por dónde empezar ahora mismo

**¿Listo para comenzar?**

1. **Si aún no has instalado Docker**: Ve a [03-instalacion-docker-compose.md](03-instalacion-docker-compose.md)
2. **Si ya tienes Docker instalado**: Empieza con [01-que-es-docker.md](01-que-es-docker.md)
3. **Si solo quieres consultar comandos**: Salta a [04-comandos-basicos.md](04-comandos-basicos.md)

**Tu primer ejercicio práctico**:
Intenta ejecutar este ejemplo simple después de instalar Docker:

```bash
# Crear un archivo docker-compose.yml
cat << 'EOF' > docker-compose.yml
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
echo "<h1>¡Mi primer contenedor Docker!</h1>" > html/index.html

# Iniciar el contenedor
docker compose up -d

# Abrir en navegador: http://localhost:8080

# Ver logs
docker compose logs

# Detener
docker compose down
```

---

**¡Éxito en tu aprendizaje de Docker! 🐳**

*Recuerda: La práctica hace al maestro. No tengas miedo de experimentar y cometer errores.*