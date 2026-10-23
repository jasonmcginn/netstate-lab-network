# Step 7: Check your work, and save it as code

**Goal:** Confirm every leak is closed, then save the firewall rules so Phase 3 starts the same way every time. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-7/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-7/)

### 1. Run the Phase 3 check

```
docker compose exec client-a sh /lab/tests/check-phase3.sh
```

### 2. Save your firewall rules

Phase 3 adds the HTTPS rule to the firewall. Save the rules to a file.

```
docker compose exec fw sh -c "iptables-save -t filter > /captures/my-rules.v4"
```

### 3. Compare with the answer key

```
docker compose exec fw sh -c "grep -- '^-A' /lab/config/fw/phase3-rules.v4 > /tmp/key; grep -- '^-A' /captures/my-rules.v4 | diff /tmp/key - && echo MATCH"
```

## You should see

- The check: `7 passed, 0 failed`.
- The compare: `MATCH`.

## What it means

The firewall change is in a file (`config/fw/phase3-rules.v4`), next to Phase 1's. The service fixes, removing Telnet, the certificate, the SSH key, the web login, are steps a build script would run, not one-off typing. That's the shape of the whole lab: every change lives as code, so it can be rebuilt, reviewed and checked.

## Phase 3 done

The leaks are shut: no Telnet, an encrypted web login, SSH on keys, and a separate login for each service. Phase 4 puts the legacy port knock next to the modern ways of doing the same job.

---

[Previous: Container hardening (shown, not a task)](06-container-hardening-shown-not-a-task.md) · [Next phase: Phase 4: modern remote access](../phase-4/README.md)
