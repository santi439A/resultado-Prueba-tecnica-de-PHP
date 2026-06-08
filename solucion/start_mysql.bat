@echo off
REM Script para iniciar MySQL si no esta corriendo
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo MySQL ya esta corriendo
    exit /b 0
)
echo Iniciando MySQL...
start /B "" "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" "--defaults-file=C:\ProgramData\MySQL\MySQL Server 8.4\Data\my.ini"
timeout /t 5 /nobreak >NUL
echo MySQL iniciado
