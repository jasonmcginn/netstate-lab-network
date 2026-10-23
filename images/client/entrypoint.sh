#!/bin/sh
# Start-up: send traffic for the other network through fw, never around it.
# ROUTE_TO = the other network, ROUTE_VIA = fw's address on this network (both set in compose.yaml).
set -e

# No default route: the lab has no way out, and no way round fw.
ip route del default 2>/dev/null || true

if [ -n "$ROUTE_TO" ] && [ -n "$ROUTE_VIA" ]; then
  ip route replace "$ROUTE_TO" via "$ROUTE_VIA"
  echo "[$(hostname)] route: $ROUTE_TO via $ROUTE_VIA (fw)"
fi

echo "[$(hostname)] routes:"
ip route

exec sleep infinity
