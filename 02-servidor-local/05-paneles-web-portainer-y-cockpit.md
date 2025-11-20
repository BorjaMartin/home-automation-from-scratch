
# 🐳 EMPEZAMOS CON PORTAINER (El más simple)

````

version: '3.8'

services:
  # Portainer - Interfaz gráfica para gestionar Docker
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer:/data

```

Explicación:

````
**`portainer:`**

**¿Qué es?**
El nombre de nuestro servicio. Puedes llamarlo como quieras, pero es buena práctica usar nombres descriptivos.

**¿Por qué portainer?**
Es el nombre del software que vamos a ejecutar.

---

**`image: portainer/portainer-ce:latest`**

**¿Qué es una imagen de Docker?**
Una "plantilla" o "paquete" que contiene:
- El software (Portainer en este caso)
- Todas sus dependencias
- Sistema operativo base
- Configuración inicial


**`restart: unless-stopped`** --> Define la política de reinicio del contenedor.

---

### Opciones disponibles

| Valor            | Comportamiento                                                  |
|------------------|-----------------------------------------------------------------|
| `no`             | Nunca reiniciar automáticamente                                 |
| `always`         | Siempre reiniciar (incluso si lo paras manualmente)             |
| `on-failure`     | Solo reiniciar si falla (código de error)                       |
| `unless-stopped` | Reiniciar siempre, **EXCEPTO** si lo paras tú manualmente       |

---

### ¿Por qué usar `unless-stopped`?

Es la opción **perfecta para servidores**:

- ✅ Si el servidor se reinicia → El contenedor arranca automáticamente  
- ✅ Si el contenedor crashea → Se reinicia solo  
- ✅ Si TÚ lo paras manualmente → Respeta tu decisión y **no se reinicia** 


**`ports: 9000:9000`**
Mapeo puertos del contenedor a puertos del host (tu servidor).

**¿Cómo funciona?**
```
Internet/Red Local
       │
       ▼
Tu Servidor (192.168.1.33:9000)
       │
       ▼
Docker redirige al contenedor (Portainer:9000)
```


### **`volumes:`**

**¿Qué son los volúmenes?**
Conexiones entre carpetas del host (tu servidor) y carpetas dentro del contenedor.

**¿Por qué son necesarios?**
Los contenedores son **efímeros** (temporales). Si borras el contenedor, pierdes todos los datos.

**Sin volúmenes:**
```
Contenedor → Datos dentro
             ↓
         Borras contenedor
             ↓
         ❌ Datos perdidos
```

**Con volúmenes:**
```
Contenedor → Datos en tu servidor (/home/user/servidor/portainer)
             ↓
         Borras contenedor
             ↓
         ✅ Datos siguen en tu servidor
```

---

### **`- /var/run/docker.sock:/var/run/docker.sock`**

**¿Qué es `docker.sock`?**
Es un archivo especial (socket Unix) que permite comunicarse con el demonio de Docker.

**¿Demonio de Docker?**
El programa principal de Docker que gestiona todos los contenedores. Siempre está corriendo en segundo plano.

**¿Por qué Portainer lo necesita?**
Portainer es una interfaz gráfica para **gestionar Docker**. Necesita comunicarse con Docker para:
- Ver contenedores
- Iniciarlos/pararlos
- Ver logs
- Crear nuevos contenedores

**Desglose:**
```
/var/run/docker.sock:/var/run/docker.sock
         │                    │
         │                    └─ Ruta dentro del contenedor
         └────────────────────── Ruta en el host
```

**Analogía:**
Es como darle a Portainer el "mando a distancia" de Docker.

**⚠️ Nota de seguridad:**
Darle acceso a `docker.sock` es darle control total de Docker. Solo hazlo con aplicaciones de confianza como Portainer.

---

### **`- ./portainer:/data`**

**Desglose:**
```
./portainer:/data
     │        │
     │        └─ Ruta dentro del contenedor
     └────────── Ruta en el host (relativa)
```

**¿Qué guarda Portainer en /data?**

- Configuraciones
- Usuarios y contraseñas
- Preferencias de la interfaz
- Base de datos interna

**¿Por qué es importante?**
Si actualizas Portainer (nueva imagen), tus configuraciones y usuarios se mantienen porque están en tu servidor, no dentro del contenedor.


## Levantar Portainer
```
docker compose up -d

`-d`
# Los contenedores corren en segundo plano
# Puedes cerrar la terminal, siguen corriendo
# ✅ Ideal para servidores


### **4. Ver qué está pasando**

Verás algo como esto:

[+] Running 2/2
 ✔ Network servidor_default      Created
 ✔ Container portainer           Started

```
image.png