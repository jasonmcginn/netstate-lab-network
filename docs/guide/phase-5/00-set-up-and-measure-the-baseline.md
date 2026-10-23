# Step 0: Set up, and measure the baseline

**Goal:** Start a throughput test between the client and the server, and record the link's speed before any shaping. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/step-0/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/step-0/)

### 1. Rebuild and load the firewall

```
docker compose up -d --build
```
```
docker compose exec fw sh -c "iptables-restore < /lab/config/fw/phase1-rules.v4"
```

### 2. Open the throughput-test port

`iperf3` uses port 5201. Allow it through the firewall for the test.

```
docker compose exec fw iptables -I FORWARD 5 -i lan -o dmz -p tcp --dport 5201 -j ACCEPT
```

### 3. Start the test server

```
docker compose exec -d server iperf3 -s
```

### 4. Measure the baseline

Latency first, then throughput.

```
docker compose exec client-a ping -c 4 10.10.20.10
```
```
docker compose exec client-a iperf3 -c 10.10.20.10 -t 4
```

### 5. Check whether this host can do delay and loss

The delay and loss steps need `netem`. This tells you if your host has it.

```
docker compose exec fw sh -c "tc qdisc add dev dmz root netem delay 1ms && echo 'netem: available' && tc qdisc del dev dmz root || echo 'netem: not available on this host (skip the delay and loss steps)'"
```

## You should see

- Ping: a fraction of a millisecond. These containers sit on one machine.
- iperf3: a very high rate (several Gbit/s), for the same reason.
- The netem check: either `available` or `not available`.

## What it means

This is the "before." It's fast and clean because there's no real network between the machines, only the host. Shaping adds the problems a real link would have, so you can watch an application meet them. Note your baseline numbers; every later step is compared against them.

---

[Phase steps](README.md) · [Next: Cap the bandwidth](01-cap-the-bandwidth.md)
