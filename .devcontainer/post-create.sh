#!/usr/bin/env bash
# Runs once after container creation — sets a random VNC password

VNC_PASS=$(openssl rand -base64 12 | tr -d '/+=' | head -c 16)
VNC_PASSWD_FILE="/usr/local/etc/vscode-dev-containers/vnc-passwd"

if [ -f "$VNC_PASSWD_FILE" ]; then
  printf '%s' "$VNC_PASS" | vncpasswd -f | sudo tee "$VNC_PASSWD_FILE" >/dev/null
  echo "[claude-browser] VNC password rotated (saved to ~/.vnc-password)"
  echo "$VNC_PASS" > ~/.vnc-password
  chmod 600 ~/.vnc-password
  echo "[claude-browser] Run: cat ~/.vnc-password  to see it if needed"
else
  echo "[claude-browser] VNC passwd file not found — skipping rotation"
fi
