@echo off
cd /d "%~dp0"
title Entretien chaudiere - ouverture directe
set "PORT=5200"
echo.
echo Ouverture directe de Entretien chaudiere V 0.24...
echo.
set "PYTHON=C:\Users\Shadow\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
if not exist "%PYTHON%" set "PYTHON=python"
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% .*LISTENING"') do taskkill /F /PID %%a >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5182 .*LISTENING"') do taskkill /F /PID %%a >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5192 .*LISTENING"') do taskkill /F /PID %%a >nul 2>nul
start "Entretien chaudiere - serveur web V 0.24" /min /D "%~dp0build\web" "%PYTHON%" -m http.server %PORT% --bind 127.0.0.1
timeout /t 2 >nul
start "" "http://127.0.0.1:%PORT%/?v=0.24-%RANDOM%"
echo.
echo Si Chrome ne s'ouvre pas, copie cette adresse:
echo http://127.0.0.1:%PORT%/?v=0.24
echo.
pause
