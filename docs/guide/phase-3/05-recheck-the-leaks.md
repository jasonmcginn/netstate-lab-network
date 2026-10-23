# Step 5: Recheck the leaks

**Goal:** Go back to the three Phase 1 leaks and confirm each one is now closed. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-5/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-5/)

Phase 1 left three leaks. This step checks all three, the same way you first found them, and confirms they're shut.

### Leak 1: the readable Telnet login

Telnet is gone, so there's nothing to connect to.

```
docker compose exec client-a nmap -n -p 23 10.10.20.10
```

### Leak 2: the readable web password

Capture a web login and search it for the password, as in Phase 1 step 4. It now goes over HTTPS.

```
docker compose exec -d fw tcpdump -i any -nn -U --immediate-mode -w /captures/recheck.pcap "tcp port 80 or tcp port 443"
```
```
docker compose exec client-a curl -sk -o /dev/null -d "username=webadmin&password=Web-Only-7788" https://10.10.20.10/login
```
```
docker compose exec fw pkill tcpdump
```
```
docker compose exec fw sh -c "tcpdump -r /captures/recheck.pcap -nn -A 2>/dev/null | grep -ac Web-Only-7788"
```

### Leak 3: the password that opened the shell

The server no longer accepts a password for SSH.

```
docker compose exec client-a ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no netstate@10.10.20.10 true
```

### All three at once

```
docker compose exec client-a sh /lab/tests/check-phase3.sh
```

## You should see

- Leak 1: `23/tcp closed` (or `filtered`).
- Leak 2: `0`. The password isn't in the capture.
- Leak 3: `Permission denied (publickey)`.
- The check: `7 passed, 0 failed`.

## What it means

Every weakness Phase 1 found is now closed, checked the same way it was first shown. That before and after, run in the same lab, is the proof: not that the fixes should work, but that they do.

---

[Previous: A separate login for each service](04-a-separate-login-for-each-service.md) · [Next: Container hardening (shown, not a task)](06-container-hardening-shown-not-a-task.md)
