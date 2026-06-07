@echo off
cd /d "%~dp0"
title Entretien chaudiere - V 0.25
set "PORT=5200"
set "FLUTTER=C:\Users\Shadow\develop\flutter\bin\flutter.bat"
if not exist "%FLUTTER%" set "FLUTTER=flutter"
echo.
echo ==================================================
echo   Entretien chaudiere - V 0.25
echo ==================================================
echo.
echo Etape 1/3 - Mise a jour de l'application...
echo Cela peut prendre 30 a 60 secondes.
echo.
"%FLUTTER%" build web --pwa-strategy=none
if errorlevel 1 (
  echo.
  echo ERREUR: la compilation Flutter a echoue.
  echo Copie ce message et envoie-le moi.
  pause
  exit /b 1
)
echo.
echo Etape 2/3 - Demarrage du serveur local...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% .*LISTENING"') do taskkill /F /PID %%a >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5182 .*LISTENING"') do taskkill /F /PID %%a >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5192 .*LISTENING"') do taskkill /F /PID %%a >nul 2>nul
set "PYTHON=C:\Users\Shadow\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
if not exist "%PYTHON%" set "PYTHON=python"
start "Entretien chaudiere - serveur web V 0.25" /min /D "%~dp0build\web" "%PYTHON%" -m http.server %PORT% --bind 127.0.0.1
timeout /t 2 >nul
echo.
echo Etape 3/3 - Ouverture de Chrome...
start "" "http://127.0.0.1:%PORT%/?v=0.25-%RANDOM%"
echo.
echo Si Chrome ne s'ouvre pas, copie cette adresse:
echo http://127.0.0.1:%PORT%/?v=0.25
echo.
echo Tu peux fermer cette fenetre apres ouverture de l'application.
pause
