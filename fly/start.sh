#!/usr/bin/env bash
# Entrypoint del contenedor — funciona en Railway y Fly.io

PORT="${PORT:-8080}"
DISPLAY_ID=":1"
VNC_PORT=5900
NOVNC_PORT=6080
CHROME_PROFILE="/home/claude/.config/chromium-claude"
NOVNC_DIR="/opt/novnc"

echo "[claude] Iniciando..."

# --- Auth ---
mkdir -p /run/claude
ACCESS_PASS="${ACCESS_PASS:-$(openssl rand -base64 16 | tr -d '/+=')}"
htpasswd -cb /run/claude/.htpasswd claude "$ACCESS_PASS"
echo "[claude] *** CONTRASENA DE ACCESO: $ACCESS_PASS ***"

# --- Directorios y permisos (volumen Railway monta como root) ---
mkdir -p "$CHROME_PROFILE"
chmod -R 777 "$CHROME_PROFILE"

# --- Nginx con puerto dinamico ---
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -c /etc/nginx/nginx.conf

# --- Display virtual ---
echo "[claude] Iniciando Xvfb..."
Xvfb "$DISPLAY_ID" -screen 0 1920x1080x24 -ac +extension RANDR +extension GLX +render -noreset &
for i in $(seq 1 15); do
    DISPLAY=$DISPLAY_ID xdpyinfo >/dev/null 2>&1 && break
    sleep 1
done

# --- VNC server ---
echo "[claude] Iniciando x11vnc..."
x11vnc \
    -display "$DISPLAY_ID" \
    -forever -nopw -shared \
    -noxrecord -noxfixes -noxdamage \
    -localhost \
    2>/tmp/x11vnc.log &

# --- noVNC (WebSocket bridge) ---
echo "[claude] Iniciando noVNC..."
websockify \
    --web "$NOVNC_DIR" \
    --heartbeat 30 \
    "$NOVNC_PORT" "127.0.0.1:$VNC_PORT" \
    2>/tmp/websockify.log &

sleep 2

# --- Limpiar locks del perfil de sesiones anteriores ---
rm -f "$CHROME_PROFILE/SingletonLock" "$CHROME_PROFILE/SingletonCookie" "$CHROME_PROFILE/SingletonSocket"

# --- Chromium como root (evita problemas de permisos con volumen Railway) ---
echo "[claude] Lanzando Chromium -> claude.ai"
(
    while true; do
        DISPLAY=$DISPLAY_ID chromium \
            --no-sandbox \
            --disable-dev-shm-usage \
            --disable-gpu \
            --disable-namespace-sandbox \
            --start-maximized \
            --app=https://claude.ai \
            --no-first-run \
            --disable-infobars \
            --disable-translate \
            --disable-features=TranslateUI,PasswordLeakDetection \
            --renderer-process-limit=1 \
            --user-data-dir="$CHROME_PROFILE" \
            >/tmp/chromium.log 2>&1
        EXIT_CODE=$?
        echo "[claude] Chromium cerrado (exit $EXIT_CODE). Reiniciando en 3s..."
        echo "[claude] --- chromium.log ---"
        tail -20 /tmp/chromium.log | while IFS= read -r line; do echo "[chromium] $line"; done
        sleep 3
    done
) &

echo "[claude] Listo."
wait
