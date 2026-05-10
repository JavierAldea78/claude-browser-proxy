@echo off
:: Lanzador Claude — abre Claude en modo app (sin barra de navegador)
:: Edita APP_URL con tu URL y contrasena de Fly.io antes de usar.

set APP_URL=https://claude:CAMBIA_ESTA_CONTRASENA@claude-browser-javier.fly.dev/vnc.html?autoconnect=true^&resize=scale

:: Intenta Edge (siempre disponible en Windows corporativo)
set EDGE="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
set CHROME="C:\Program Files\Google\Chrome\Application\chrome.exe"

if exist %EDGE% (
    start "" %EDGE% --app="%APP_URL%" --window-size=1280,800
    goto :fin
)

if exist %CHROME% (
    start "" %CHROME% --app="%APP_URL%" --window-size=1280,800
    goto :fin
)

:: Fallback: abre en el navegador por defecto
start "" "%APP_URL%"

:fin
