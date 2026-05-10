#!/usr/bin/env bash
# Starts Chromium pointing to claude.ai with an auto-restart watchdog.
# Runs every time the container starts (postStartCommand).

DISPLAY_ID=":1"
CHROMIUM_LOG="/tmp/chromium.log"
TARGET_URL="https://claude.ai"

echo "[claude-browser] Waiting for display ${DISPLAY_ID}..."
for i in $(seq 1 30); do
  DISPLAY=$DISPLAY_ID xdpyinfo >/dev/null 2>&1 && break
  sleep 2
done

if ! DISPLAY=$DISPLAY_ID xdpyinfo >/dev/null 2>&1; then
  echo "[claude-browser] ERROR: Display ${DISPLAY_ID} not available after 60s. Aborting."
  exit 1
fi

echo "[claude-browser] Display ready. Starting Chromium watchdog -> ${TARGET_URL}"

# Kill any leftover Chromium from a previous run
pkill -f "chromium.*claude.ai" 2>/dev/null || true
sleep 1

# Watchdog loop: restart Chromium if it exits (e.g. OOM, crash)
(
  while true; do
    DISPLAY=$DISPLAY_ID chromium \
      --no-sandbox \
      --disable-setuid-sandbox \
      --disable-dev-shm-usage \
      --disable-gpu \
      --start-maximized \
      --app="${TARGET_URL}" \
      --no-first-run \
      --disable-translate \
      --disable-infobars \
      --disable-session-crashed-bubble \
      --disable-features=TranslateUI,PasswordLeakDetection \
      --enable-features=WebRTCPipeWireCapturer \
      --user-data-dir=/home/vscode/.config/chromium-claude \
      2>"${CHROMIUM_LOG}"
    EXIT_CODE=$?
    echo "[claude-browser] Chromium exited (code ${EXIT_CODE}). Restarting in 3s..."
    sleep 3
  done
) &

WATCHDOG_PID=$!
echo "[claude-browser] Watchdog PID ${WATCHDOG_PID}. Open port 6080 in the Ports panel."
