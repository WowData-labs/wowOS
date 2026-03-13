#!/bin/bash
# Run once on first boot to install Raspberry Pi desktop and set graphical boot.
# State file prevents running again on next boot. Log to stderr so journalctl shows it.
set -e
STATE_FILE="/var/lib/wowos/desktop-installed"
log() { echo "wowos-install-desktop: $*" >&2; }

mkdir -p /var/lib/wowos
if [ -f "$STATE_FILE" ]; then
  log "already done, skipping"
  exit 0
fi

log "installing desktop packages (apt update + raspberrypi-ui-mods, chromium, unclutter)..."
for attempt in 1 2 3; do
  if apt-get update -qq && apt-get install -y -qq raspberrypi-ui-mods chromium unclutter; then
    break
  fi
  log "attempt $attempt failed, retry in 15s..."
  sleep 15
done
if ! dpkg -s raspberrypi-ui-mods &>/dev/null; then
  log "ERROR: apt install failed after retries. Run: journalctl -u wowos-install-desktop-once.service"
  exit 1
fi

log "setting default target to graphical"
systemctl set-default graphical.target

log "writing autostart entry for wowOS Launcher"
mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/wowos-launcher.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=wowOS Launcher
Exec=chromium --kiosk --noerrdialogs --disable-infobars --no-first-run --check-for-update-interval=31536000 http://localhost:9090/
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=wowOS desktop home
EOF

touch "$STATE_FILE"
log "desktop install done. Reboot to enter graphical desktop."
