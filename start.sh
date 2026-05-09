#!/bin/bash
set -e

echo "Starting virtual display..."
Xvfb :99 -screen 0 1280x900x24 -ac +extension GLX +render -noreset &
export DISPLAY=:99
sleep 2

echo "Starting VNC server..."
x11vnc -display :99 -nopw -listen 127.0.0.1 -forever -shared -rfbport 5900 -quiet &
sleep 1

echo "Starting noVNC on port 6080..."
websockify --web=/usr/share/novnc/ 0.0.0.0:6080 127.0.0.1:5900 &
sleep 2

echo "Opening Claude in Chromium..."
DISPLAY=:99 chromium \
    --no-sandbox \
    --disable-gpu \
    --disable-dev-shm-usage \
    --window-size=1280,900 \
    --start-maximized \
    "https://claude.ai" &

echo ""
echo "Claude is ready!"
echo "Open the forwarded port 6080 or navigate to:"
echo "  https://\${CODESPACE_NAME}-6080.preview.app.github.dev/vnc.html?autoconnect=true&resize=scale"

wait
