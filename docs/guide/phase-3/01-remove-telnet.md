# Step 1: Remove Telnet

**Goal:** Take the plain-text Telnet service off the server for good. (5 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-1/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-1/)

Telnet sends everything in clear text (Phase 1, step 4). The fix is not to configure it more carefully; it's to remove it. SSH does the same job, encrypted.

### 1. Stop the Telnet service

Telnet runs from `inetd` on the server. Stop it.

```
docker compose exec server pkill inetd
```

### 2. Confirm it's gone

```
docker compose exec server ss -ltn
```
```
docker compose exec client-a nmap -n -p 23 10.10.20.10
```

## You should see

- `ss` no longer lists a listener on `:23`.
- nmap: `23/tcp closed telnet` (or `filtered`, since the firewall also blocks it).

## What it means

The service is off, so there's nothing to connect to even from the server itself. This is defence in depth: the firewall already blocked Telnet after Phase 1's lockdown, and now the service is gone too. The cleanest way to secure a protocol you don't need is to remove it.

---

[Previous: Start from Phase 1's end](00-start-from-phase-1s-end.md) · [Next: Move the web server to HTTPS](02-move-the-web-server-to-https.md)
