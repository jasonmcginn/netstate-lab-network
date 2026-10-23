# Step 9: Host firewalls

**Goal:** Find which firewall is blocking: fw, the server's own, or the client's own. Two planted faults, one method. (15 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-9/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-9/)

fw isn't the only firewall in the path. The server and each client run their own, called a **host firewall**. When something's blocked, the question is always: where does the packet stop?

The method, for both faults: **(1)** does fw log the connection, **(2)** where does a capture on fw see the packet, **(3)** what do the host's own rules say.

## Fault 1: the server

### 1. Plant the fault

This blocks web traffic in the server's own firewall.

```
docker compose exec server iptables -A INPUT -p tcp --dport 80 -j DROP
```
```
docker compose exec client-a curl -s -m 5 http://10.10.20.10/
```

The web page times out, even though fw allows web.

### 2. Did fw block it?

```
docker compose exec fw sh -c "grep DPT=80 /captures/fw.log | tail -n 2"
```

Only `FW-NEW` lines, no `FW-DROP`: fw let it through.

### 3. Where does the packet stop?

```
docker compose exec -d fw tcpdump -i any -nn -U --immediate-mode -w /captures/step9.pcap "tcp port 80"
```
```
docker compose exec client-a curl -s -m 4 http://10.10.20.10/
```
```
docker compose exec fw pkill tcpdump
```
```
docker compose exec fw tcpdump -nn -r /captures/step9.pcap
```

### 4. Check the server's own firewall, and fix it

```
docker compose exec server iptables -L INPUT -n -v --line-numbers
```
```
docker compose exec server iptables -D INPUT 1
```
```
docker compose exec client-a curl -s -m 5 -o /dev/null -w "%{http_code}\n" http://10.10.20.10/
```

## Fault 2: the client

### 5. Plant the fault

This blocks outgoing SSH in client-a's own firewall.

```
docker compose exec client-a iptables -A OUTPUT -p tcp --dport 22 -j DROP
```

### 6. Capture on fw while client-a tries SSH

```
docker compose exec -d fw tcpdump -i any -nn -U --immediate-mode -w /captures/step9b.pcap "tcp port 22"
```
```
docker compose exec client-a ssh -o ConnectTimeout=4 netstate@10.10.20.10
```
```
docker compose exec fw pkill tcpdump
```
```
docker compose exec fw sh -c "tcpdump -r /captures/step9b.pcap -nn 2>/dev/null | wc -l"
```

### 7. Check client-a's own firewall, and fix it

The check script looks for leftover blocking rules too:

```
docker compose exec client-a sh /lab/tests/check-phase1.sh
```
```
docker compose exec client-a iptables -L OUTPUT -n -v --line-numbers
```
```
docker compose exec client-a iptables -D OUTPUT 1
```
```
docker compose exec client-a sh /lab/tests/check-phase1.sh
```

## You should see

**Fault 1, the server:**

- The capture: the request comes in on `lan` and goes out on `dmz`, again and again, and no reply ever comes back:

```
lan  In  IP 10.10.10.11.36424 > 10.10.20.10.80: Flags [S] ...
dmz  Out IP 10.10.10.11.36424 > 10.10.20.10.80: Flags [S] ...
```

- The server's rules: `DROP ... tcp dpt:80`, with a packet count that went up with each try. After removing it: `200`.

**Fault 2, the client:**

- SSH: `Connection timed out`.
- The capture on fw: `0`. The packet never left client-a.
- The check: `FAIL  ssh :22` and `FAIL  no blocking rules left in client-a's own firewall`. After removing it: `6 passed, 0 failed`.

## What it means

Same symptom, a timeout, with three possible places to look. The capture on fw splits them:

| fw's capture shows | The block is |
|---|---|
| Nothing at all | Before fw: the client's own firewall (or its route) |
| In on `lan`, nothing out on `dmz`, and a `FW-DROP` in the log | fw itself |
| Out on `dmz`, no reply | After fw: the server's own firewall |

Work from the middle out, and you find any firewall fault in three checks.

---

[Previous: step 8](08-the-way-around.md) · [Phase 1 steps](README.md) · [Next: step 10](10-check-your-work.md)
