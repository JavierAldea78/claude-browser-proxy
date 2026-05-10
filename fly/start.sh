#!/usr/bin/env bash
# Entrypoint del contenedor cloud — arranca todo y mantiene el proceso vivo.

set -e

DISPLAY_ID=":1"
RESOLUTION="${RESOLUTION:-1280x800x24}"
VNC_PORT=5900
NOVNC_PORT=6080
DATA_DIR="${DATA_DIR:-/data}"
CHROME_PROFILE="$DATA_DIR/chromium-profile"

echo "[claude] Configurando autenticacion..."
mkdir -p /run/claude
ACCESS_PASS="${ACCESS_PASS:-$(openssl rand -base64 16 | tr -d '/+=')}"
htpasswd -cb /run/claude/.htpasswd claude "$ACCESS_PASS"
echo "[claude] Contrasena de acceso: $ACCESS_PASS"
echo "[claude] URL: https://$(hostname).fly.dev/vnc.html?autoconnect=true&resize=scale"

echo "[claude] Creando directorio de datos en $DATA_DIR..."
mkdir -p "$CHROME_PROFILE"
chown -R claude:claude "$DATA_DIR" 2>/dev/null || true

echo "[claude] Iniciando display virtual $DISPLAY_ID ($RESOLUTION)..."
Xvfb "$DISPLAY_ID" -screen 0 "$RESOLUTION" -ac +extension GLX +render -noreset &
XVFB_PID=$!

# Esperar display
for i in $(seq 1 20); do
    DISPLAY=$DISPLAY_ID xdpyinfo >/dev/null 2>&1 && break
    sleep 1
done

echo "[claude] Iniciando servidor VNC..."
x11vnc \
    -display "$DISPLAY_ID" \
    -forever \
    -nopw \
    -shared \
    -noxrecord \
    -noxfixes \
    -noxdamage \
    -localhost \
    2>/var/log/x11vnc.log &

echo "[claude] Iniciando noVNC (websockify)..."
websockify \
    --web /usr/share/novnc \
    --heartbeat 30 \
    --timeout 86400 \
    "$NOVNC_PORT" \
    "127.0.0.1:$VNC_PORT" \
    2>/var/log/websockify.log &

echo "[claude] Iniciando nginx (proxy con auth)..."
nginx

echo "[claude] Lanzando Chromium -> claude.ai"
# Watchdog: reinicia Chromium si se cae
(
    while true; do
        su claude -c "DISPLAY=$DISPLAY_ID chromium \
            --no-sandbox \
            --disable-setuid-sandbox \
            --disable-dev-shm-usage \
            --disable-gpu \
            --start-maximized \
            --app=https://claude.ai \
            --no-first-run \
            --disable-infobars \
            --disable-translate \
            --disable-features=TranslateUI,PasswordLeakDetection \
            --user-data-dir=$CHROME_PROFILE \
            2>/var/log/chromium.log"
        echo "[claude] Chromium cerrado. Reiniciando en 3s..."
        sleep 3
    done
) &

echo "[claude] Todo arrancado. Esperando..."
wait $XVFB_PID
