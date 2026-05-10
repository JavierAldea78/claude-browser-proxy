@echo off
:: Lanzador Claude — abre Claude en modo app (sin barra de navegador)

set APP_URL=https://claude:Q2CjSkjHZFDr0LLeaXzpg@claude-browser-production.up.railway.app/claude.html

:: Intenta Edge (siempre disponible en Windows corporativo)
set EDGE="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
set CHROME="C:\Program Files\Google\Chrome\Application\chrome.exe"

if exist %EDGE% (
    start "" %EDGE% --app="%APP_URL%" --window-size=1920,1080
    goto :fin
)

if exist %CHROME% (
    start "" %CHROME% --app="%APP_URL%" --window-size=1920,1080
    goto :fin
)

:: Fallback: abre en el navegador por defecto
start "" "%APP_URL%"

:fin
