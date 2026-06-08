# 🧪 PHP Technical Test - Soluciones

Este repositorio contiene la solución completa a **dos pruebas técnicas de PHP + MySQL**.

---

## 📋 ¿Qué hay aquí?

| Carpeta | Contenido |
|---------|-----------|
| `solucion prueba tecnica/` | 1ª prueba: tabla `items` y `invoices` con promociones |
| `solucion challenge 2 junior-main/` | 2ª prueba: tabla `products` y `orders` con descuentos |
| `start.bat` | Lanzador automático para **Windows** |
| `start.sh` | Lanzador automático para **Linux / macOS / WSL** |

Cada carpeta contiene:
- `challenge.php` → La solución completa (4 ejercicios por prueba)
- `database.php` → Clase para conectar a MySQL
- `*.sql` → Datos de la base de datos
- `*.json` → Promociones / descuentos
- `start_mysql.bat` → Script auxiliar para arrancar MySQL en Windows

---

## 🚀 Quick Start (para impacientes)

### Windows
```batch
start.bat
```
El menú te guiará. Solo necesitas **PHP** y **MySQL** instalados.

### Linux / macOS
```bash
chmod +x start.sh
./start.sh
```

---

## 📖 Qué hace cada ejercicio

### Prueba 1 — `solucion prueba tecnica/`

| # | Qué hace |
|---|----------|
| 1 | Se conecta a MySQL y lista los productos de la tabla `items` |
| 2 | Lee `promotions.json` y lo muestra como array de PHP |
| 3 | Recorre las facturas (`invoices`), calcula subtotales y aplica descuentos si la categoría supera el umbral |
| 4 | Convierte los subtotales a pesos colombianos usando la API https://open.er-api.com/ |

### Prueba 2 — `solucion challenge 2 junior-main/`

| # | Qué hace |
|---|----------|
| 1 | Se conecta a MySQL y lista los productos de la tabla `products` |
| 2 | Lee `discount.json` y lo muestra como array de PHP |
| 3 | Recorre las órdenes (`orders`), calcula totales y aplica descuentos según categoría y umbral |
| 4 | Convierte los totales a pesos colombianos usando la misma API |

---

## 🛠️ Cómo ejecutar (paso a paso)

### ▶️ Opción 1: Lanzador automático (recomendado)

El lanzador hace todo por ti: verifica PHP y MySQL, crea las bases de datos, importa los datos y arranca el servidor.

**Windows:**
```batch
start.bat
```
Te aparecerá un menú. Elige `1` o `2` y se abrirá tu navegador.

**Linux / macOS / WSL:**
```bash
chmod +x start.sh
./start.sh
```

### ▶️ Opción 2: Manual (si prefieres control total)

**Paso 1 — Crear las bases de datos:**
```bash
mysql -u root -h 127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS training CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -h 127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS challenge CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

**Paso 2 — Importar los datos:**
```bash
mysql -u root -h 127.0.0.1 training --default-character-set=utf8mb4 < "solucion prueba tecnica/store.sql"
mysql -u root -h 127.0.0.1 challenge --default-character-set=utf8mb4 < "solucion challenge 2 junior-main/data.sql"
```

**Paso 3 — Iniciar servidor web:**

Para ver el resultado en el navegador:
```bash
# Primera prueba
php -S localhost:8000 -t "solucion prueba tecnica"
# Abre http://localhost:8000/challenge.php

# Segunda prueba (en otra terminal)
php -S localhost:8001 -t "solucion challenge 2 junior-main"
# Abre http://localhost:8001/challenge.php
```

**Paso 4 — O ver directo en consola (sin navegador):**
```bash
php "solucion prueba tecnica/challenge.php"
php "solucion challenge 2 junior-main/challenge.php"
```

### ▶️ Opción 3: Solo revisar el código (sin instalar nada)

Abre los archivos en cualquier editor:
- `solucion prueba tecnica/challenge.php`
- `solucion challenge 2 junior-main/challenge.php`

No necesitas PHP ni MySQL para leer el código.

### ▶️ Opción 4: Docker

Si tienes Docker instalado, crea un archivo `docker-compose.yml` con esto:

```yaml
services:
  php:
    image: php:8.3-cli
    ports:
      - "8000:8000"
      - "8001:8001"
    volumes:
      - ".:/app"
    working_dir: /app
    command: bash -c "docker-php-ext-install pdo_mysql && php -S 0.0.0.0:8000 -t 'solucion prueba tecnica' & php -S 0.0.0.0:8001 -t 'solucion challenge 2 junior-main' & wait"
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
    ports:
      - "3306:3306"
    volumes:
      - "./solucion prueba tecnica/store.sql:/docker-entrypoint-initdb.d/01-store.sql"
      - "./solucion challenge 2 junior-main/data.sql:/docker-entrypoint-initdb.d/02-data.sql"
```

Y ejecuta:
```bash
docker-compose up
```

---

## 📦 Instalación de requisitos

### Windows

| Método | Cómo |
|--------|------|
| **XAMPP** (más fácil) | Descarga de https://www.apachefriends.org/ e instala. Usa el panel para iniciar MySQL |
| **winget** (automático) | `winget install PHP.PHP.8.3` y `winget install Oracle.MySQL` |
| **Laragon** (portable) | Descarga de https://laragon.org/ — trae PHP + MySQL + Apache listos |

> ⚠️ Después de instalar, verifica que `php` y `mysql` funcionen en la terminal. Si no, agrega las carpetas al PATH manualmente.

### macOS
```bash
brew install php
brew install mysql
brew services start mysql
```

### Linux (Ubuntu/Debian)
```bash
sudo apt install php-cli php-mysql php-curl mysql-server
sudo systemctl start mysql
```

### Verificar que todo está listo
```bash
php -v                    # Debe mostrar la versión
php -m | grep pdo_mysql   # Debe mostrar "pdo_mysql"
mysql --version           # Debe mostrar la versión
mysql -u root -h 127.0.0.1 -e "SELECT 1;"   # Debe responder "1"
```

---

## ❗ Solución de problemas

| Error | Causa | Solución |
|-------|-------|----------|
| `PDOException: could not find driver` | Falta extensión `pdo_mysql` | En `php.ini`, descomenta `extension=pdo_mysql` |
| `Can't connect to MySQL server` | MySQL no está corriendo | Inicia MySQL (XAMPP panel, `brew services`, `systemctl`) |
| `Class "Database" not found` | PHP no encuentra `database.php` | Ejecuta `challenge.php` desde la raíz del proyecto |
| Caracteres extraños (Ã±, Ã³) | Codificación incorrecta al importar | Usa `--default-character-set=utf8mb4` en el comando `mysql` |
| `php` no se reconoce | PHP no está en PATH | Agrega la carpeta de PHP a las variables de entorno |

---

## 📁 Explicación del código

Dentro de cada `challenge.php` encontrarás comentarios detallados línea por línea explicando:
- **Qué hace cada función de PHP** (`file_get_contents`, `json_decode`, `print_r`, `number_format`, etc.)
- **Por qué se usó cada enfoque**
- **Cómo funciona la lógica de descuentos** (comparación de categorías, umbrales, cálculo de porcentajes)

--- 

## 📌 Notas técnicas

- Las soluciones usan **PDO** (PHP Data Objects) para la conexión a MySQL
- Las credenciales son: `root` / sin contraseña / `127.0.0.1`
- Los datos SQL deben importarse con `utf8mb4` para soportar caracteres acentuados
- El bonus (ejercicio 4) consume la API pública https://open.er-api.com/ — requiere internet
- Compatible con PHP 8.x y MySQL 8.x
