#!/bin/sh
# The NetState Lab Network: Phase 3 check my work.
#   docker compose exec client-a sh /lab/tests/check-phase3.sh
# Confirms every Phase 1 leak is closed. Run it on client-a. Changes nothing.
SERVER=10.10.20.10
pass=0; fail=0
check(){ if [ "$2" = "$3" ]; then echo "PASS  $1"; pass=$((pass+1)); else echo "FAIL  $1 (expected $2, got $3)"; fail=$((fail+1)); fi; }

echo "Phase 3 check on $(hostname)"
via=$(ip route get "$SERVER" | grep -o 'via [0-9.]*' | cut -d' ' -f2)
check "route to the DMZ goes via fw" 10.10.10.1 "$via"

if timeout 3 sh -c "</dev/tcp/$SERVER/23" 2>/dev/null; then t=open; else t=closed; fi
check "telnet :23 removed" closed "$t"

code=$(curl -s -o /dev/null -w "%{http_code}" "http://$SERVER/login")
check "web :80 redirects to HTTPS" 301 "$code"

code=$(curl -sk -o /dev/null -w "%{http_code}" "https://$SERVER/")
check "web :443 serves HTTPS" 200 "$code"

if ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o BatchMode=yes -o ConnectTimeout=5 netstate@"$SERVER" true 2>/dev/null; then s=accepted; else s=refused; fi
check "ssh password login refused" refused "$s"

if ssh -o BatchMode=yes -o ConnectTimeout=5 netstate@"$SERVER" true 2>/dev/null; then k=works; else k=fails; fi
check "ssh key login works" works "$k"

code=$(curl -sk -o /dev/null -w "%{http_code}" -d "username=netstate&password=LabOnly-2026" "https://$SERVER/login")
check "old shared password no longer opens the web" 401 "$code"

echo "---"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
