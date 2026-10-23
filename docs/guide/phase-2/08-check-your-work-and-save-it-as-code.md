# Step 8: Check your work, and save it as code

**Goal:** Confirm the knock hides the doors, then save the firewall rules so Phase 2 starts the same way every time. (10 min)

### 1. Check both clients

The check sends the knock from client-a and confirms the doors open for it and stay shut for the outsider.

```
docker compose exec client-a sh /lab/tests/check-phase2.sh
```
```
docker compose exec client-b sh /lab/tests/check-phase2.sh
```

### 2. Save your firewall rules

```
docker compose exec fw sh -c "iptables-save -t filter > /captures/my-rules.v4"
```

### 3. Compare with the answer key

The knock watcher adds its own short-lived rule, so the compare ignores that line.

```
docker compose exec fw sh -c "grep -- '^-A' /lab/config/fw/phase2-rules.v4 > /tmp/key; iptables-save -t filter | grep -- '^-A' | grep -v 'knock door' | diff /tmp/key - && echo MATCH"
```

## You should see

- client-a: `7 passed, 0 failed`. client-b: `5 passed, 0 failed`.
- The compare: `MATCH`.

## What it means

The firewall's permanent rules now hide SSH and RDP; the only thing that opens them is a knock the watcher reads from the log. The rules live in a file (`config\fw\phase2-rules.v4`), next to Phase 1's, so the whole setup can be rebuilt, reviewed and checked.

## Phase 2 done

You hid remote access behind a knock, opened it with the secret, watched the timers, and then broke it three ways: a replayed knock, guessing that got banned, and a reused password that walked past the ban. Phase 3 closes those leaks for good.

---

[Previous: Break it: the reused password walks past](07-break-it-the-reused-password-walks-past.md) · [Next phase: Phase 3: fix the leaks](../phase-3/README.md)
