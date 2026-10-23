#!/bin/sh
# Server start-up: route back through fw, create the lab user, start services.
set -e

# No default route: the lab has no way out, and no way round fw.
ip route del default 2>/dev/null || true
if [ -n "$ROUTE_TO" ] && [ -n "$ROUTE_VIA" ]; then
  ip route replace "$ROUTE_TO" via "$ROUTE_VIA"
  echo "[server] route: $ROUTE_TO via $ROUTE_VIA (fw)"
fi

# Lab-only user (from config/lab.env)
if ! id "$LAB_USER" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$LAB_USER"
fi
echo "$LAB_USER:$LAB_PASS" | chpasswd
echo "[server] lab user: $LAB_USER"

# SSH: fresh host keys for this container, then start
ssh-keygen -A >/dev/null
mkdir -p /run/sshd
# Logins go to /var/log/auth.log (no syslog in a container; Fail2Ban reads it in Phase 2)
touch /var/log/auth.log
/usr/sbin/sshd -E /var/log/auth.log
echo "[server] ssh    :22  up (log: /var/log/auth.log)"

# Telnet, via inetd
/usr/sbin/inetd /etc/inetd.conf
echo "[server] telnet :23  up"

# Web, in the foreground so its requests show in the container log
echo "[server] web    :80  starting"
exec python3 /opt/web/app.py
