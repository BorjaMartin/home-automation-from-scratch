# Linux

## Comandos Linux
¿Qué es un comando de Linux?
Un comando Linux es un programa o utilidad que se ejecuta en la CLI, una consola que interactúa con el sistema a través de textos y procesos. Es similar al Símbolo del sistema en Windows.

Los comandos de Linux se ejecutan en el terminal pulsando Enter al final de la línea. Puedes ejecutar comandos para realizar diversas tareas, desde la instalación de paquetes hasta la gestión de usuarios y la manipulación de archivos

| #  | Comando       | Descripción breve                                                     |
|----|--------------|----------------------------------------------------------------------|
| 1  | `ls`         | Lista archivos y directorios del directorio actual.                  |
| 2  | `cd`         | Cambia el directorio de trabajo actual.                              |
| 3  | `pwd`        | Muestra la ruta del directorio actual.                               |
| 4  | `cat`        | Muestra el contenido de uno o varios archivos; también puede crear.  |
| 5  | `mkdir`      | Crea un nuevo directorio.                                            |
| 6  | `rmdir`      | Elimina un directorio, solo si está vacío.                           |
| 7  | `touch`      | Crea un archivo vacío o actualiza la fecha de uno existente.         |
| 8  | `rm`         | Elimina archivos o directorios (con cuidado).                        |
| 9  | `cp`         | Copia uno o varios archivos a otro directorio.                       |
| 10 | `sudo`       | Ejecuta un comando con privilegios de superusuario.                  |
| 11 | `top`        | Muestra procesos en ejecución, uso de CPU/memoria en tiempo real.    |
| 12 | `man`        | Muestra el manual de un comando; ayuda para ver opciones.            |
| 13 | `zip`/`unzip`| Comprime (`zip`) y descomprime (`unzip`) archivos .zip.              |
| 14 | `tar`        | Herramienta para agrupar y comprimir archivos/directorios.           |
| 15 | `locate`     | Busca archivos por nombre en el sistema, rápido.                     |
| 16 | `find`       | Busca archivos/directorios usando criterios (nombre, tipo, fecha…).  |
| 17 | `mv`         | Mueve o renombra archivos/directorios.                               |
| 18 | (repite `cp`)| **Nota**: el artículo lo repite como comando #18.                    |
| 19 | `df`         | Muestra el espacio libre/ocupado en sistemas de archivos.            |
| 20 | `du`         | Muestra el tamaño que ocupan archivos/directorios.                   |
| 21 | `chmod`      | Cambia los permisos de acceso de archivos o directorios.              |
| 22 | `kill`       | Finaliza procesos indicados por su PID o señal.                      |
| 23 | `ping`       | Comprueba la conectividad de red hacia un servidor/dominio.           |
| 24 | `grep`       | Busca texto dentro de archivos usando patrones.                       |
| 25 | `wget`       | Descarga archivos desde URL o FTP directamente desde la terminal.     |



# Bash
## Lenguaje Bash

### Comandos básicos

Comandos básicos

Para poder trabajar eficientemente en BASH, es indispensable conocer los comandos más básicos. Aquí hay una pequeña lista que debemos conocer a la perfección:

| Comando                       |  Descripción                          | Ejemplo de uso               |
| ----------------------------- |  ------------------------------------ | ---------------------------- |
| `cat fich1 […fichN]`          |  Concatena y muestra un archivo       | `cat /etc/passwd`            |
| `cd [dir]`                    |  Cambia de directorio                 | `cd /tmp`                    |
| `chmod permisos fich`         |  Cambia los permisos de un archivo    | `chmod +x miscript`          |
| `chown usuario:grupo fich`    |  Cambia el dueño de un archivo        | `chown nobody miscript`      |
| `cp fich1…fichN dir`          |  Copia archivos                       | `cp foo foo.backup`          |
| `diff [-e] arch1 arch2`       |  Encuentra diferencias entre archivos | `diff foo.c newfoo.c`        |
| `du [-sabr] fich`             |  Reporta el tamaño del directorio     | `du -s /home/`               |
| `file arch`                   |  Muestra el tipo de un archivo        | `file arc_desconocido`       |
| `find dir test acción`        |  Encuentra archivos                   | `find . -name “.bak” -print` |
| `grep [-cilnv] expr archivos` |  Busca patrones en archivos           | `grep mike /etc/passwd`      |
| `head -count fich`            |  Muestra el inicio de un archivo      | `head prog1.c`               |
| `mkdir dir`                   |  Crea un directorio                   | `mkdir temp`                 |
| `mv fich1…fichN dir`          |  Mueve un archivo(s) a un directorio  | `mv a.out prog1`             |


## Herramientas básicas

| Herramienta     | ¿Qué hace?                                        | Alternativas modernas | Instalación (apt)                | Instalación (dnf)                | Instalación (pacman)         |
|-----------------|---------------------------------------------------|------------------------|---------------------------------|----------------------------------|------------------------------|
| **curl**         | Descargar archivos desde URLs                    | —                      | `sudo apt install curl`         | `sudo dnf install curl`          | `sudo pacman -S curl`        |
| **wget**         | Descargar archivos (alternativa a curl)          | —                      | `sudo apt install wget`         | `sudo dnf install wget`          | `sudo pacman -S wget`        |
| **git**          | Control de versiones                             | —                      | `sudo apt install git`          | `sudo dnf install git`           | `sudo pacman -S git`         |
| **nano**         | Editor de texto en terminal                      | `vim`, `nvim`          | `sudo apt install nano`         | `sudo dnf install nano`          | `sudo pacman -S nano`        |
| **htop**         | Monitor de procesos interactivo                  | `btop`, `top`          | `sudo apt install htop`         | `sudo dnf install htop`          | `sudo pacman -S htop`        |
| **net-tools**    | Herramientas de red (ifconfig, netstat)          | `ip`, `ss`             | `sudo apt install net-tools`    | `sudo dnf install net-tools`     | `sudo pacman -S net-tools`   |
| **ufw**          | Firewall sencillo (Uncomplicated Firewall)       | `firewalld`            | `sudo apt install ufw`          | *No disponible nativamente*      | *No disponible nativamente*  |

## 🔐 CHMOD +X - PERMISOS EN LINUX

```
chmod +x ~/setup-servidor.sh
```

¿Qué son los permisos en Linux?
En Linux, cada archivo tiene permisos que determinan:

Quién puede acceder (usuario, grupo, otros)
Qué puede hacer (leer, escribir, ejecutar)

```
ls -l setup-servidor.sh
-rw-r--r-- 1 borja borja 2048 Nov 1 10:00 setup-servidor.sh
```

**Desglose:**
```
-rw-r--r--
│││ │ │ │
│││ │ │ └─ Otros: r (read - leer)
│││ │ └─── Grupo: r (read)
│││ └───── Usuario: rw (read + write - leer y escribir)
││└─────── Tipo: - (archivo normal)
│└──────── ...
└───────── ...


**Tipos de permisos:**
- `r` = Read (leer) = 4
- `w` = Write (escribir) = 2
- `x` = eXecute (ejecutar) = 1

### **¿Qué hace `chmod +x`?**

**Desglose:**
- `chmod` = Change mode (cambiar permisos)
- `+x` = Añadir (+) permiso de ejecución (x)

**Antes del comando:**

-rw-r--r--  (644)
El archivo se puede leer y escribir, pero NO ejecutar.

**Después del comando:**
-rwxr-xr-x  (755)

```

## 📄 ARCHIVOS YAML - ¿QUÉ SON?
YAML = "YAML Ain't Markup Language"
Es un formato de archivo para escribir configuraciones de forma legible.

### Características:
1. Sensible a la indentación (como Python)

```
servicios:
  web:
    puerto: 80
  db:
    puerto: 3306
```

2. Usa espacios, NO tabs

```
correcto:
  con: espacios  ✅

incorrecto:
→con: tabs  ❌  (esto romperá)
```
3. Estructura de clave-valor

```
nombre: "Mi Servidor"
ip: 192.168.1.100
puertos:
  - 80
  - 443
```

¿Por qué Docker Compose usa YAML?
Porque es:

✅ Legible por humanos
✅ Fácil de editar
✅ Jerárquico (servicios dentro de servicios)
✅ Soporta comentarios

Ejemplo básico:
```
version: '3.8'

services:
  web:
    image: nginx
    ports:
      - "80:80"
```
Traducción:
"Crea un servicio llamado 'web', usa la imagen 'nginx', y expone el puerto 80"

