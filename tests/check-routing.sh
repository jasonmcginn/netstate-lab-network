#!/bin/sh
# Session one check: run inside client-a.
#   docker compose exec client-a sh /lab/tests/check-routing.sh
# Reports PASS or FAIL for each check. Changes nothing.

SERVER=10.10.20.10
FW=10.10.10.1
pass=0; fail=0
ok()  { echo "PASS  $1"; pass=$((pass+1)); }
bad() { echo "FAIL  $1"; fail=$((fail+1)); }

ip route | grep -q "10.10.20.0/24 via $FW" \
  && ok "route to the DMZ goes via fw ($FW)" \
  || bad "route to the DMZ goes via fw ($FW)"

ip route | grep -q '^default' \
  && bad "no default route (no way out of the lab)" \
  || ok  "no default route (no way out of the lab)"

ping -c 2 -W 2 "$SERVER" >/dev/null 2>&1 \
  && ok "server ($SERVER) answers" \
  || bad "server ($SERVER) answers"

first=$(traceroute -n -m 2 -w 2 "$SERVER" 2>/dev/null | awk 'NR==2{print $2}')
[ "$first" = "$FW" ] \
  && ok "first hop to the server is fw ($first)" \
  || bad "first hop to the server is fw (got: ${first:-nothing})"

ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1 \
  && bad "internet unreachable" \
  || ok  "internet unreachable"

echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
