Todos esto pasos están en el script: 

sudo ufw default deny incoming
sudo ufw default allow outgoing

Configuración de firewall UFW
¿Qué es un firewall?
Un sistema que controla qué conexiones de red están permitidas.
sudo ufw default deny incoming
Significado:

ufw = Uncomplicated Firewall
default = Configuración por defecto
deny = Denegar/Bloquear
incoming = Conexiones entrantes

¿Qué hace?
"Por defecto, BLOQUEA todas las conexiones que intenten entrar al servidor desde fuera".
¿Por qué?
Seguridad. Empezamos bloqueando todo, y luego abrimos solo los puertos que necesitamos.

sudo ufw default allow outgoing
Significado:

allow = Permitir
outgoing = Conexiones salientes

¿Qué hace?
"Por defecto, PERMITE todas las conexiones que el servidor inicie hacia fuera".
¿Por qué?
Para que tu servidor pueda:

Descargar actualizaciones
Hacer peticiones web
Conectarse a internet libremente

sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS

Abrir puertos específicos
Desglose:

allow = Permitir
22/tcp = Puerto 22, protocolo TCP

¿Qué es un puerto?
Un "canal" numérico donde un servicio escucha conexiones.
Analogía:
Tu casa (servidor) tiene una dirección (IP: 192.168.1.33). Los puertos son como diferentes puertas:

Puerto 22 = Puerta para SSH (terminal remoto)
Puerto 80 = Puerta para HTTP (web sin encriptar)
Puerto 443 = Puerta para HTTPS (web encriptada)
Puerto 8123 = Puerta para Home Assistant
etc.

¿TCP vs UDP?

TCP = Transmission Control Protocol (conexiones confiables, con confirmación)
UDP = User Datagram Protocol (más rápido, sin confirmación)

Ejemplos de uso:

TCP: Web, email, SSH (necesitan que lleguen todos los datos)
UDP: Streaming, videojuegos, VoIP (velocidad > confiabilidad)

sudo ufw --force enable

Activar el firewall
Desglose:

enable = Activar
--force = Forzar (no preguntar confirmación)

¿Qué hace?
Activa UFW para que empiece a aplicar las reglas que configuramos.
¿Por qué --force?
Normalmente UFW pregunta: "¿Activar firewall? Podrías perder conexión SSH". Con --force asume que sí.
¿Es seguro en nuestro caso?
Sí, porque YA abrimos el puerto 22 (SSH) antes de activarlo.

mkdir -p ~/servidor/{home-assistant,n8n,nextcloud...}
Crear estructura de carpetas

mkdir -p ~/servidor/{home-assistant,n8n,nextcloud}
```

**¿Por qué `-p`?**
Sin `-p`, si `~/servidor` no existe, daría error. Con `-p`, crea todas las carpetas necesarias.

**¿Por qué esta estructura?**
Docker guarda datos persistentes en el host. Cada servicio necesita su carpeta para guardar:
- Configuraciones
- Bases de datos
- Archivos de usuario
- Logs

**Resultado:**

/home/borja/servidor/
├── home-assistant/
├── n8n/
├── nextcloud/
├── wireguard/
├── portainer/
└── ...
```


# Para ejecutar el script.
nano ~/setup-servidor.sh

Copiamos y pegamos el código de 02-servidor-local/recursos/setup-servidor.sh

Guarda (Ctrl+O, Enter, Ctrl+X) y ejecuta:
```
chmod +x ~/setup-servidor.sh
./setup-servidor.sh
```
