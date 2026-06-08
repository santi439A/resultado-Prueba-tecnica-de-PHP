@echo off
title PHP Challenge - Launcher
chcp 65001 >nul

echo ============================================
echo   PHP Technical Test - Solution Launcher
echo ============================================
echo.

REM --- Check PHP ---
where php >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] PHP no encontrado.
    echo   Instala PHP desde: https://windows.php.net/download/
    echo   O usa XAMPP: https://www.apachefriends.org/
    echo.
    echo   Despues de instalar, asegurate de que php este en el PATH.
    pause
    exit /b 1
)
for /f "delims=" %%i in ('php -r "echo PHP_VERSION;"') do set PHPVER=%%i
echo [OK] PHP %PHPVER% encontrado
echo.

REM --- Check MySQL ---
set MYSQL_FOUND=0
where mysql >nul 2>nul
if %ERRORLEVEL% equ 0 (
    set MYSQL_FOUND=1
    echo [OK] MySQL encontrado en PATH
) else (
    REM Buscar en rutas comunes
    for %%p in (
        "C:\Program Files\MySQL\MySQL Server 8.4\bin"
        "C:\Program Files\MySQL\MySQL Server 8.0\bin"
        "C:\xampp\mysql\bin"
        "C:\laragon\bin\mysql\mysql-8.0\bin"
        "C:\wamp64\bin\mysql\mysql8.0\bin"
        "%ProgramFiles%\MySQL\MySQL Server 8.4\bin"
        "%ProgramFiles%\MySQL\MySQL Server 8.0\bin"
        "%ProgramW6432%\MySQL\MySQL Server 8.4\bin"
        "%ProgramW6432%\MySQL\MySQL Server 8.0\bin"
    ) do (
        if exist "%%~p\mysql.exe" (
            set "MYSQL_PATH=%%~p"
            set "PATH=%%~p;%PATH%"
            set MYSQL_FOUND=1
            echo [OK] MySQL encontrado en: %%~p
            goto :mysql_found
        )
    )
)

:mysql_found
if %MYSQL_FOUND% equ 0 (
    echo [WARN] MySQL no encontrado en el sistema.
    echo   Los ejercicios que requieren BD no funcionaran sin MySQL.
    echo   Instala XAMPP, Laragon o MySQL desde: https://dev.mysql.com/downloads/
    echo.
    echo   Para solo revisar el codigo, abre los archivos .php en un editor.
    echo.
    pause
    exit /b 1
)

REM --- Test MySQL connection ---
echo.
echo Verificando conexion a MySQL...
mysql -u root -h 127.0.0.1 -e "SELECT 1;" >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [WARN] MySQL no esta corriendo.
    echo   Opcion 1: Inicia MySQL manualmente desde XAMPP/Laragon
    echo   Opcion 2: Ejecuta el script start_mysql.bat de cada carpeta
    echo.
    echo   O puedes revisar el codigo directamente sin servidor.
    pause
    exit /b 1
)
echo [OK] Conexion a MySQL exitosa

REM --- Ensure databases and tables exist ---
echo.
echo Verificando base de datos 'training'...
mysql -u root -h 127.0.0.1 -e "SELECT COUNT(*) FROM training.items;" >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Creando BD training e importando datos...
    mysql -u root -h 127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS training CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -h 127.0.0.1 training --default-character-set=utf8mb4 < "solucion prueba tecnica\store.sql"
    echo [OK] BD training lista
) else (
    echo [OK] BD training existe
)

echo Verificando base de datos 'challenge'...
mysql -u root -h 127.0.0.1 -e "SELECT COUNT(*) FROM challenge.products;" >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Creando BD challenge e importando datos...
    mysql -u root -h 127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS challenge CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -h 127.0.0.1 challenge --default-character-set=utf8mb4 < "solucion challenge 2 junior-main\data.sql"
    echo [OK] BD challenge lista
) else (
    echo [OK] BD challenge existe
)

REM --- Let user choose ---
echo.
echo ============================================
echo   SELECCIONA UN EJERCICIO:
echo ============================================
echo.
echo   1) Prueba tecnica 1 - Items y facturas
echo   2) Challenge 2 Junior - Products y orders
echo   3) Salir
echo.
set /p CHOICE="Elige (1-3): "

if "%CHOICE%"=="1" (
    set PORT=8000
    set DIR=solucion prueba tecnica
    set FILE=challenge.php
) else if "%CHOICE%"=="2" (
    set PORT=8001
    set DIR=solucion challenge 2 junior-main
    set FILE=challenge.php
) else (
    echo Saliendo...
    exit /b 0
)

REM --- Start PHP server ---
echo.
echo Iniciando servidor en http://localhost:%PORT%/%FILE%
echo Abre tu navegador en esa direccion.
echo Presiona Ctrl+C para detener el servidor.
echo.
php -S localhost:%PORT% -t "%DIR%"
