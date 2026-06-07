@echo off
set "APP_DIR=%~dp0"
start "Entretien chaudiere Flutter" powershell -NoExit -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; cd '%APP_DIR%'; $flutter='C:\Users\Shadow\develop\flutter\bin\flutter.bat'; if (!(Test-Path $flutter)) { $flutter='flutter' }; Write-Host 'Lancement de l''application Flutter...' -ForegroundColor Cyan; & $flutter pub get; & $flutter run -d chrome --web-port 5181"
