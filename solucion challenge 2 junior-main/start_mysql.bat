@echo off
REM Script para iniciar MySQL si no esta corriendo
REM Busca MySQL en rutas comunes del sistema
chcp 65001 >nul

title MySQL Starter

REM Verificar si MySQL ya esta corriendo
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] MySQL ya esta corriendo
    exit /b 0
)

REM Buscar mysqld.exe en rutas comunes
set MYSQLD=
set DATADIR=

for %%p in (
    "%ProgramFiles%\MySQL\MySQL Server 8.4\bin\mysqld.exe"
    "%ProgramFiles%\MySQL\MySQL Server 8.0\bin\mysqld.exe"
    "%ProgramFiles(x86)%\MySQL\MySQL Server 8.4\bin\mysqld.exe"
    "%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\mysqld.exe"
    "C:\xampp\mysql\bin\mysqld.exe"
    "C:\laragon\bin\mysql\mysql-8.0\bin\mysqld.exe"
    "C:\laragon\bin\mysql\mysql-5.7\bin\mysqld.exe"
    "C:\wamp64\bin\mysql\mysql8.0\bin\mysqld.exe"
    "C:\wamp64\bin\mysql\mysql5.7\bin\mysqld.exe"
    "%LOCALAPPDATA%\Programs\MySQL\MySQL Server 8.4\bin\mysqld.exe"
) do (
    if exist "%%~p" (
        set "MYSQLD=%%~p"
        goto :found
    )
)

:found
if "%MYSQLD%"=="" (
    echo [ERROR] MySQL no encontrado.
    echo   Instala XAMPP, Laragon o MySQL desde:
    echo   https://dev.mysql.com/downloads/
    pause
    exit /b 1
)

echo [OK] MySQL encontrado: %MYSQLD%

REM Intentar iniciar con posibles datadir
for %%d in (
    "%ProgramData%\MySQL\MySQL Server 8.4\Data"
    "%ProgramData%\MySQL\MySQL Server 8.0\Data"
    "C:\xampp\mysql\data"
    "C:\laragon\data\mysql"
) do (
    if exist "%%~d" (
        set "DATADIR=%%~d"
        goto :start
    )
)

:start
if not "%DATADIR%"=="" (
    echo Iniciando MySQL con datadir: %DATADIR%
    start /B "" "%MYSQLD%" "--datadir=%DATADIR%"
) else (
    echo Iniciando MySQL...
    start /B "" "%MYSQLD%"
)

timeout /t 5 /nobreak >NUL
echo [OK] MySQL iniciado (o ya estaba corriendo)
