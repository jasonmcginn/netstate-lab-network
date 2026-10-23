# Step 4: Timers

**Goal:** Watch the three timers work: the door closes, a session already open stays up, and an idle one is dropped. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/step-4/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/step-4/)

The legacy design had three timers. In the lab they're shortened so you can watch them:

| Timer | Lab | Original |
|---|---|---|
| Time to finish the knock | 30 seconds | 1 minute |
| Time the door stays open | 60 seconds | 5 minutes |
| Idle time before a session drops | 2 minutes | 15 minutes |

### 1. Knock, and open a session that keeps talking

This session prints the time every 10 seconds for 90 seconds, so it outlives the door.

```
docker compose exec client-a knock 10.10.20.10 4747 3043 3043 9034
```
```
docker compose exec client-a ssh netstate@10.10.20.10 "for i in 1 2 3 4 5 6 7 8 9; do date +%T; sleep 10; done"
```

Type the password when asked, then watch it.

### 2. Check the door closed

```
docker compose exec fw tail -n 1 /captures/knock.log
```

### 3. Try a new connection now

```
docker compose exec client-a ssh -o ConnectTimeout=5 netstate@10.10.20.10
```

### 4. Knock, sign in, and go quiet

Knock, sign in, then don't type anything for **2½ minutes**. Then press Enter.

```
docker compose exec client-a knock 10.10.20.10 4747 3043 3043 9034
```
```
docker compose exec client-a ssh netstate@10.10.20.10
```

If the session freezes after you press Enter, close it with Enter, then `~` and `.` (three keys, one after another).

## You should see

- Step 1: nine timestamps, 10 seconds apart, even though the door closed partway through.
- Step 2: `door closed (sessions already open stay up)`.
- Step 3: `Connection timed out`. The door is shut to new connections.
- Step 4: after 2½ minutes of silence, the session doesn't answer. fw forgot it.

## What it means

The door only controls **new** connections. A session already open rides on Phase 1's stateful rule (rule 2) and stays up while it's in use. But fw only remembers a connection while it's active: after 2 minutes of silence it forgets it, and the next packet looks like a stranger and is dropped. That's the idle timer, and it's what stops a forgotten session from staying open forever.

To change a timer, edit `config\fw\knock.conf`, then restart the watcher: `docker compose exec fw knock-watcher stop`, then `docker compose exec fw knock-watcher start`.

---

[Previous: One packet by hand](03-one-packet-by-hand.md) · [Next: Break it: replay the knock](05-break-it-replay-the-knock.md)
