# Step 1: Cap the bandwidth

**Goal:** Limit the link to a slow speed and measure the drop, the one shaping this lab verifies with real numbers. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/step-1/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/step-1/)

Bandwidth limiting uses `tbf` (token bucket filter). It's available on essentially any Linux host, so this is the step with measured results.

### 1. Add a 5 Mbit cap on the firewall

This shapes traffic leaving the firewall toward the server (the `dmz` side).

```
docker compose exec fw tc qdisc add dev dmz root tbf rate 5mbit burst 32kbit latency 400ms
```

### 2. Measure again

```
docker compose exec client-a iperf3 -c 10.10.20.10 -t 4
```

### 3. Remove the cap and confirm it recovers

```
docker compose exec fw tc qdisc del dev dmz root
```
```
docker compose exec client-a iperf3 -c 10.10.20.10 -t 4
```

## You should see

The throughput falls to about the cap you set, then returns to full speed when you remove it. In the lab:

```
before:  ~13000 Mbits/sec
5mbit cap:   ~4.5 Mbits/sec
after:   ~13000 Mbits/sec
```

(Your baseline will differ; the capped figure will sit just under 5 Mbit/s whatever it is.)

## What it means

The firewall held the traffic to the rate you set, no matter how fast the two machines could actually talk. This is how you test an application the way a user on a slow connection would meet it, a branch office on a thin link, a phone on mobile data, without leaving your desk. Change `5mbit` to `1mbit` or `256kbit` and measure again.

---

[Previous: Set up, and measure the baseline](00-set-up-and-measure-the-baseline.md) · [Next: Add delay and loss](02-add-delay-and-loss.md)
