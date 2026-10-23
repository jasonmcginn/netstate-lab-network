# Step 3: Watch the traffic: two views

**Goal:** See the same traffic two ways: the firewall's log and a packet capture. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-3/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-3/)

The firewall writes a line to a log for every new connection it passes. A packet capture records every packet on the wire. You'll use both for the rest of the lab.

### 1. Ping the server, then read the firewall log

```
docker compose exec client-a ping -c 2 -W 2 10.10.20.10
```
```
docker compose exec fw tail -n 3 /captures/fw.log
```

The log is also a plain file at `captures\fw.log` in the lab folder.

### 2. Start a packet capture on the firewall

This runs tcpdump on fw in the background, on both of its network cards, saving every ping packet to a file.

```
docker compose exec -d fw tcpdump -i any -nn -U --immediate-mode -w /captures/step3.pcap icmp
```

### 3. Ping again, then stop the capture

```
docker compose exec client-a ping -c 2 -W 2 10.10.20.10
```
```
docker compose exec fw pkill tcpdump
```

### 4. Read the capture

```
docker compose exec fw tcpdump -nn -r /captures/step3.pcap
```

## You should see

The log, one line per connection:

```
fw FW-NEW IN=lan OUT=dmz ... SRC=10.10.10.11 DST=10.10.20.10 ... PROTO=ICMP
```

The capture, four lines for each ping:

```
lan  In  IP 10.10.10.11 > 10.10.20.10: ICMP echo request
dmz  Out IP 10.10.10.11 > 10.10.20.10: ICMP echo request
dmz  In  IP 10.10.20.10 > 10.10.10.11: ICMP echo reply
lan  Out IP 10.10.20.10 > 10.10.10.11: ICMP echo reply
```

## What it means

The log is short: who talked to whom, and which way through the firewall (`IN=lan OUT=dmz`). It's what you search first in an incident. The capture is the full record: the request comes in on `lan` and goes out on `dmz`, and the reply comes back the other way. That's routing, seen directly.

The `.pcap` file in the `captures` folder also opens in Wireshark.

---

[Previous: step 2](02-find-your-way-around.md) · [Phase 1 steps](README.md) · [Next: step 4](04-services-on-the-wire.md)
