# Step 8: The way around

**Goal:** Give traffic a second path that skips the firewall, and learn the three signs that give it away. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-8/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-8/)

A firewall only protects the paths that go through it. Each lab network also has a second gateway, Docker's own, at `.254`. Here you'll close fw completely, then send traffic around it.

### 1. Close fw completely

Insert a drop-everything rule as rule 2, just after the logging rule, so blocked traffic still gets logged.

```
docker compose exec fw iptables -I FORWARD 2 -j DROP
```
```
docker compose exec client-a ping -c 2 -W 2 10.10.20.10
```

The ping fails, as it should.

### 2. Add a second path

Two commands: point client-a at Docker's gateway instead of fw, and point the server back the same way.

```
docker compose exec client-a ip route replace 10.10.20.0/24 via 10.10.10.254
```
```
docker compose exec server ip route replace 10.10.10.0/24 via 10.10.20.254
```

### 3. Capture on fw while you ping

```
docker compose exec -d fw tcpdump -i any -nn -U --immediate-mode -w /captures/step8.pcap icmp
```
```
docker compose exec client-a ping -c 2 -W 2 10.10.20.10
```
```
docker compose exec fw pkill tcpdump
```

### 4. Look for the three signs

The capture on fw (how many packets it saw):

```
docker compose exec fw sh -c "tcpdump -r /captures/step8.pcap -nn 2>/dev/null | wc -l"
```

The first hop on the way to the server:

```
docker compose exec client-a traceroute -n -m 1 -w 2 10.10.20.10
```

The check script:

```
docker compose exec client-a sh /lab/tests/check-phase1.sh
```

### 5. Put it back

Restarting the two machines restores their routes through fw. Then remove the drop-everything rule.

```
docker compose restart client-a server
```
```
docker compose exec fw iptables -D FORWARD 2
```
```
docker compose exec client-a sh /lab/tests/check-phase1.sh
```

## You should see

- With fw closed, the second ping gets replies: `0% packet loss`.
- The capture on fw: `0`. The firewall never saw a single packet.
- The first hop: `10.10.10.254`, not fw (`10.10.10.1`).
- The check: `FAIL  route to the DMZ goes via fw`.
- After putting it back: `6 passed, 0 failed`.

## What it means

The firewall was fully closed and the server still answered, because the traffic never went near it. Nothing in fw's log or capture shows anything wrong; the evidence is in what's missing. That's why the route check matters: it looks at the path, not the rules.

One more thing to notice: if you try the web page over the bypass, it fails. Docker runs its own firewall on the `.254` gateway, and it only lets ping through. So the bypass ran straight into another firewall. That's the subject of the next step.

Real-world versions of this: a server with a second network card, a forgotten static route, a VPN that sends traffic around the firewall.

---

[Previous: Open for purpose](07-open-for-purpose.md) · [Next: Host firewalls](09-host-firewalls.md)
