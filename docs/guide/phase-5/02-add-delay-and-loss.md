# Step 2: Add delay and loss

**Goal:** Use netem to make the link slow and lossy, and watch latency climb and packets disappear. (15 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/step-2/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/step-2/)

This step needs `netem`. If step 0's check said it isn't available on your host, read this page and come back to it on a machine that has it (most desktop Linux, and WSL2).

### 1. Add 100 ms of delay

```
docker compose exec fw tc qdisc add dev dmz root netem delay 100ms
```
```
docker compose exec client-a ping -c 4 10.10.20.10
```

### 2. Add jitter, so the delay varies

```
docker compose exec fw tc qdisc change dev dmz root netem delay 100ms 20ms
```
```
docker compose exec client-a ping -c 6 10.10.20.10
```

### 3. Add packet loss

```
docker compose exec fw tc qdisc change dev dmz root netem delay 100ms 20ms loss 20%
```
```
docker compose exec client-a ping -c 20 10.10.20.10
```

### 4. Remove the shaping

```
docker compose exec fw tc qdisc del dev dmz root
```

## You should see

- With delay, the ping round-trip climbs from a fraction of a millisecond to roughly the delay you added.
- With jitter, the round-trip varies instead of holding steady.
- With loss, the ping summary reports packets missing, near the percentage you set.

Record your own numbers here; they're the point of the step.

## What it means

Delay, jitter and loss are what a real link adds, and each breaks something different: delay slows every round trip, jitter upsets anything timing-sensitive like voice or video, and loss forces retransmits that slow a transfer far more than the loss figure alone suggests. Recreating them on purpose is how you find out what your application does on a bad connection before a user does.

---

[Previous: Cap the bandwidth](01-cap-the-bandwidth.md) · [Next: Shape, measure, restore](03-shape-measure-restore.md)
