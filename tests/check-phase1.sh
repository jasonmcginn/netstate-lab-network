#!/bin/sh
# The NetState Lab Network: Phase 1 check my work.
# Run on each client:
#   docker compose exec client-a sh /lab/tests/check-phase1.sh
#   docker compose exec client-b sh /lab/tests/check-phase1.sh
# Checks that this client gets exactly what Phase 1's policy allows. Changes nothing.

SERVER=10.10.20.10
FW=10.10.10.1
ME=$(hostname)
pass=0; fail=0

check() { # name, expected (open|blocked), actual
  if [ "$2" = "$3" ]; then echo "PASS  $1"; pass=$((pass+1));
  else echo "FAIL  $1 (expected $2, got $3)"; fail=$((fail+1)); fi
}
port() { # port -> open|blocked
  if timeout 3 bash -c "</dev/tcp/$SERVER/$1" 2>/dev/null; then echo open; else echo blocked; fi
}

case "$ME" in
  client-a) want_ssh=open ;;
  client-b) want_ssh=blocked ;;
  *) echo "Run this on client-a or client-b."; exit 2 ;;
esac

echo "Phase 1 check on $ME"
via=$(ip route get "$SERVER" | grep -o 'via [0-9.]*' | cut -d' ' -f2)
check "route to the DMZ goes via fw ($FW)" "$FW" "$via"
if ping -c 1 -W 2 "$SERVER" >/dev/null 2>&1; then p=open; else p=blocked; fi
check "ping the server (allowed for troubleshooting)" open "$p"
check "web :80 (open to the LAN)" open "$(port 80)"
check "ssh :22 ($ME: $want_ssh)" "$want_ssh" "$(port 22)"
check "telnet :23 (blocked for everyone)" blocked "$(port 23)"
if iptables -S OUTPUT 2>/dev/null | grep -q -- '-j DROP\|-j REJECT'; then h=rules; else h=clean; fi
check "no blocking rules left in $ME's own firewall" clean "$h"
echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
