# Step 0: Start from Phase 1's end

**Goal:** Rebuild the lab, load Phase 1's firewall, and confirm the leaks are still open so the fixes have a clear before and after. (5 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-0/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-0/)

### 1. Rebuild and load the Phase 1 firewall

```
docker compose up -d --build
```
```
docker compose exec fw sh -c "iptables-restore < /lab/config/fw/phase1-rules.v4"
```

### 2. Clear the server's old SSH key on the clients

The rebuilt server has a fresh key; clear the remembered one so the clients don't refuse it.

```
docker compose exec client-a ssh-keygen -R 10.10.20.10
```

### 3. See what's still open

```
docker compose exec client-a nmap -n -p 22,23,80 10.10.20.10
```

## You should see

```
22/tcp open  ssh
23/tcp open  telnet
80/tcp open  http
```

Telnet answers, the web is plain HTTP, and SSH takes a password. Those are the three leaks from Phase 1. By the end of this phase, all three are shut.

## What it means

You're starting from a working, Phase-1 network with its known weaknesses in place. Each step closes one, and the last step checks they stay closed.

---

[Phase steps](README.md) · [Next: Remove Telnet](01-remove-telnet.md)
