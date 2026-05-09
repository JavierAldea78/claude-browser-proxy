#!/usr/bin/env bash
# Wait for the virtual display to be ready, then open Claude
set -e

echo "[claude-browser] Waiting for display :1..."
for i in $(seq 1 30); do
  if DISPLAY=:1 xdpyinfo >/dev/null 2>&1; then
    echo "[claude-browser] Display ready."
    break
  fi
  sleep 2
done

echo "[claude-browser] Launching Chromium → https://claude.ai"
DISPLAY=:1 chromium-browser \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --start-maximized \
  --app=https://claude.ai \
  2>/tmp/chromium.log &

echo "[claude-browser] Done. Open port 6080 in the Ports panel."
