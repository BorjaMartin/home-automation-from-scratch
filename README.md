# 🏠 Home Automation From Scratch
Complete guide to setting up your own Smart Home with a local server and Home Assistant.

Guía completa para configurar tu propio hogar inteligente con un servidor local y Home Assistant.

**Guía completa paso a paso para montar tu sistema de domótica DIY desde cero**

Aprende a crear tu propio Smart Home utilizando un PC viejo como servidor, Home Assistant y Docker Compose. Esta guía está diseñada para personas **sin experiencia previa** en domótica, servidores o Docker.

---

## 🎯 ¿Para quién es esta guía?

- ✅ Quieres empezar en domótica pero no sabes por dónde empezar
- ✅ Tienes un PC viejo que quieres aprovechar como servidor
- ✅ Prefieres control local vs servicios en la nube
- ✅ No tienes experiencia con Docker o servidores Linux
- ✅ Buscas una guía clara, práctica y en español

---

## 📚 Contenido del Repositorio

### [📖 01 - Introducción](./01-introduccion/)
Fundamentos de domótica, protocolos y comparativa de plataformas.
- [¿Qué es la domótica?](./01-introduccion/01-que-es-la-domotica.md)
- [Protocolos domóticos](./01-introduccion/02-protocolos-domoticos.md)
- [Home Assistant vs otras opciones](./01-introduccion/03-home-assistant-vs-otras-opciones.md)
- [Ruta de aprendizaje](./01-introduccion/04-ruta-de-aprendizaje.md)
- [Documentación para principiantes](./01-introduccion/05-documentación-para-principiantes.md)

### [💻 02 - Servidor Local](./02-servidor-local/)
Prepara tu PC viejo como servidor domótico.
- [Elección de hardware](./02-servidor-local/01-eleccion-hardware.md)
- [Instalación Ubuntu Server](./02-servidor-local/02-instalacion-ubuntu-server.md)
- [Configuración de red](./02-servidor-local/03-configuracion-red.md)
- [Acceso remoto SSH](./02-servidor-local/04-acceso-remoto-ssh.md)
- [Paneles web (Portainer y Cockpit)](./02-servidor-local/05-paneles-web-portainer-y-cockpit.md)

### [🐋 03 - Docker y Docker Compose](./03-docker-y-docker-compose/)
Aprende Docker Compose desde cero (sin conocimientos previos).
- [¿Qué es Docker?](./03-docker-y-docker-compose/01-que-es-docker.md)
- [¿Qué es Docker Compose?](./03-docker-y-docker-compose/02-que-es-docker-compose.md)
- [Instalación](./03-docker-y-docker-compose/03-instalacion-docker-compose.md)
- [Comandos básicos](./03-docker-y-docker-compose/04-comandos-basicos.md)
- [Mejores prácticas](./03-docker-y-docker-compose/05-mejores-practicas.md)
- [📁 Ejemplos prácticos](./03-docker-y-docker-compose/ejemplos/)

### [🏠 04 - Home Assistant](./04-home-assistant/)
Instala y configura Home Assistant con Docker Compose.
- [Instalación con Docker Compose](./04-home-assistant/01-instalacion-docker-compose.md)
- [Primera configuración](./04-home-assistant/02-primera-configuracion.md)
- [Integraciones básicas](./04-home-assistant/03-integraciones-basicas.md)
- [Backups y seguridad](./04-home-assistant/04-backups-y-seguridad.md)

### [📡 05 - Zigbee y Matter](./05-zigbee-y-matter/)
Conecta dispositivos inalámbricos (sensores, luces, enchufes).
- [Zigbee2MQTT](./05-zigbee-y-matter/01-zigbee2mqtt.md)
- [Coordinadores Zigbee](./05-zigbee-y-matter/02-coordinadores-zigbee.md)
- [Matter y Thread](./05-zigbee-y-matter/03-matter-y-thread.md)
- [Primeros dispositivos](./05-zigbee-y-matter/04-primeros-dispositivos-zigbee.md)

### [🤖 06 - Automatizaciones](./06-automatizaciones/)
Crea automatizaciones útiles para tu hogar.
- [Primeras automatizaciones](./06-automatizaciones/01-primeras-automatizaciones.md)
- [Escenas y rutinas](./06-automatizaciones/02-escenas-y-rutinas.md)
- [Automatizaciones avanzadas](./06-automatizaciones/03-automatizaciones-avanzadas.md)
- [📁 Ejemplos YAML](./06-automatizaciones/ejemplos-yaml/)

### [🚀 07 - Avanzado](./07-avanzado/)
Funcionalidades avanzadas: acceso remoto, cámaras, NAS, etc.
- [Cloudflare Tunnel](./07-avanzado/01-cloudflare-tunnel.md)
- [Tailscale VPN](./07-avanzado/02-tailscale-vpn.md)
- [Servidor NAS con Docker](./07-avanzado/03-servidor-nas-con-docker.md)
- [Frigate - Cámaras con IA](./07-avanzado/04-frigate-camaras-ia.md)
- [Optimización y monitorización](./07-avanzado/05-optimizacion-y-monitorizacion.md)

### [🛠️ 08 - Recursos](./08-recursos/)
Cheatsheets, scripts y herramientas útiles.
- [📄 Cheatsheets](./08-recursos/cheatsheets/) - Docker, Ubuntu, Networking
- [🔧 Scripts](./08-recursos/scripts/) - Instalación, backup, actualización

### [📦 Docker Compose Files](./docker-compose/)
Templates de Docker Compose listos para usar.
- [Home Assistant](./docker-compose/homeassistant/)
- [Zigbee2MQTT](./docker-compose/zigbee2mqtt/)
- [ESPHome](./docker-compose/esphome/)
- [Mosquitto MQTT](./docker-compose/mosquitto/)
- [Full Stack](./docker-compose/full-stack/) - Todo en uno

---

## 🚀 Comienza aquí

### Ruta rápida (3 pasos):
1. **[Prepara tu servidor](./02-servidor-local/01-eleccion-hardware.md)** - Evalúa tu PC viejo
2. **[Aprende Docker Compose](./03-docker-y-docker-compose/01-que-es-docker.md)** - En 30 minutos
3. **[Instala Home Assistant](./04-home-assistant/01-instalacion-docker-compose.md)** - Y empieza

### Ruta completa (recomendada):
Sigue la guía en orden desde [01-introduccion](./01-introduccion/) para entender todo el ecosistema.

---

## 🎓 Lo que aprenderás

- ✅ Instalar y administrar un servidor Linux
- ✅ Usar Docker y Docker Compose desde cero
- ✅ Configurar Home Assistant
- ✅ Conectar dispositivos Zigbee, WiFi y Matter
- ✅ Crear automatizaciones inteligentes
- ✅ Acceder de forma segura desde cualquier lugar
- ✅ Mantener backups y actualizar servicios

---

## 💡 Stack Tecnológico

| Componente | Tecnología |
|------------|-----------|
| **Sistema Operativo** | Ubuntu Server 22.04 LTS |
| **Orquestador** | Docker Compose |
| **Plataforma Domótica** | Home Assistant |
| **Protocolo Zigbee** | Zigbee2MQTT |
| **Broker MQTT** | Mosquitto |
| **Gestión Docker** | Portainer |
| **Administración Server** | Cockpit |

---

## 📋 Requisitos Mínimos

### Hardware (PC viejo):
- **CPU**: Dual-core 1.5+ GHz (Intel/AMD)
- **RAM**: 4 GB (8 GB recomendado)
- **Almacenamiento**: 32 GB SSD/HDD (64+ GB recomendado)
- **Red**: Puerto Ethernet
- **Opcional**: Coordinador Zigbee USB (~15€)

### Conocimientos:
- **Ninguno** - Esta guía asume cero conocimientos previos
- Ganas de aprender y experimentar
- Paciencia para seguir los pasos

---

**¡Empieza tu viaje en la domótica DIY ahora! 🚀**

[👉 Ir a la Introducción](./01-introduccion/01-que-es-la-domotica.md)