#!/bin/sh
# fw start-up: routing on, firewall wide open, and every new connection logged.
set -e

# No default route: the lab has no way out.
ip route del default 2>/dev/null || true

# Name the interfaces after their networks, so logs and captures say "lan" and
# "dmz" instead of eth0/eth1 (Docker's order isn't predictable).
for pair in 10.10.10.1:lan 10.10.20.1:dmz; do
  addr=${pair%%:*}; name=${pair##*:}
  dev=$(ip -o -4 addr show | awk -v a="$addr" '$4 ~ "^"a"/" {print $2}')
  if [ -n "$dev" ] && [ "$dev" != "$name" ]; then
    ip link set dev "$dev" down
    ip link set dev "$dev" name "$name"
    ip link set dev "$name" up
  fi
done

echo "[fw] interfaces:"
ip -brief address

# Forwarding is switched on by Compose (sysctls); show it so the log proves it.
echo "[fw] ip_forward = $(cat /proc/sys/net/ipv4/ip_forward)"

# Logging: start ulogd2, then send the first packet of every new connection
# crossing fw to it (NFLOG group 1). Lines land in captures/fw.log.
mkdir -p /captures
ulogd -d -c /etc/ulogd.conf
iptables -A FORWARD -m conntrack --ctstate NEW -j NFLOG --nflog-group 1 --nflog-prefix "FW-NEW"
echo "[fw] logging every new connection to captures/fw.log"

# Wide open for now: the rules are written in Phase 1.
iptables -P FORWARD ACCEPT
echo "[fw] FORWARD policy: ACCEPT (open). Ready."

exec sleep infinity
