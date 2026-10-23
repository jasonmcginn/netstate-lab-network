#!/bin/sh
# The NetState Lab Network: Phase 2 check my work.
#   docker compose exec client-a sh /lab/tests/check-phase2.sh
#   docker compose exec client-b sh /lab/tests/check-phase2.sh
# Needs the knock watcher running on fw. On client-a it sends the knock itself,
# then checks the door opened. Changes nothing on fw except through the knock.
SERVER=10.10.20.10
ME=$(hostname)
pass=0; fail=0
check() { if [ "$2" = "$3" ]; then echo "PASS  $1"; pass=$((pass+1)); else echo "FAIL  $1 (expected $2, got $3)"; fail=$((fail+1)); fi; }
port() { if timeout 3 bash -c "</dev/tcp/$SERVER/$1" 2>/dev/null; then echo open; else echo blocked; fi; }

echo "Phase 2 check on $ME"
via=$(ip route get "$SERVER" | grep -o 'via [0-9.]*' | cut -d' ' -f2)
check "route to the DMZ goes via fw" 10.10.10.1 "$via"
check "web :80 (open to the LAN)" open "$(port 80)"
check "telnet :23 (blocked for everyone)" blocked "$(port 23)"
case "$ME" in
  client-a)
    check "ssh :22 hidden before the knock" blocked "$(port 22)"
    check "rdp :3389 hidden before the knock" blocked "$(port 3389)"
    knock "$SERVER" 4747 3043 3043 9034 >/dev/null
    sleep 2
    check "ssh :22 open after the knock" open "$(port 22)"
    check "rdp :3389 open after the knock" open "$(port 3389)" ;;
  client-b)
    check "ssh :22 hidden (no knock)" blocked "$(port 22)"
    check "rdp :3389 hidden (no knock)" blocked "$(port 3389)" ;;
  *) echo "Run this on client-a or client-b."; exit 2 ;;
esac
echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
