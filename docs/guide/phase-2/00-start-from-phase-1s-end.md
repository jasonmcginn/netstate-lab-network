# Step 0: Start from Phase 1's end

**Goal:** Rebuild the lab with the Phase 2 tools, load Phase 1's finished firewall, and read the knock's settings. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/step-0/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/step-0/)

Phase 2 adds a few tools to the lab: the knock watcher on fw, a `knock` command and `hping3` on the clients, and RDP and Fail2Ban on the server. Fail2Ban and the watcher are installed but switched off until you need them.

### 1. Rebuild the lab

```
docker compose up -d --build
```

### 2. Load Phase 1's finished firewall

This is the answer key from Phase 1 step 10: deny-all, web and ping open, SSH for client-a only.

```
docker compose exec fw sh -c "iptables-restore < /lab/config/fw/phase1-rules.v4"
```

### 3. Forget the server's old SSH key

The rebuilt server has a new SSH key. Clients that remember the old one refuse to send a password at all, so clear it on both:

```
docker compose exec client-a ssh-keygen -R 10.10.20.10
```
```
docker compose exec client-b ssh-keygen -R 10.10.20.10
```

### 4. Check Phase 1's policy is in place

```
docker compose exec client-a sh /lab/tests/check-phase1.sh
```

### 5. Read the knock's settings

```
docker compose exec fw cat /lab/config/fw/knock.conf
```

The same file is in your lab folder at `config\fw\knock.conf`.

## You should see

- The check: `6 passed, 0 failed`.
- The settings, including:

```
KNOCK_SEQUENCE="4747 3043 3043 9034"
KNOCK_FLAGS="FIN,PSH,URG"
KNOCK_WINDOW=30    # time to finish the sequence      (original: 60s, 1 minute)
DOOR_OPEN=60       # time the door stays open          (original: 300s, 5 minutes)
IDLE_DROP=120      # idle time before a session drops  (original: 900s, 15 minutes)
DOOR_PORTS="22,3389"
```

## What it means

The knock is one packet to port 4747, two to 3043, then one to 9034, each with an impossible combination of TCP flags. Send them in that order within 30 seconds and the door (SSH and RDP) opens for your address for 60 seconds. The original timers were longer; they're shortened so you can watch them work. Change a number in this file and the behaviour follows.

---

[Phase steps](README.md) · [Next: Hide](01-hide.md)
