# Step 3: SSH on keys, not passwords

**Goal:** Give client-a an SSH key, trust it on the server, and turn password logins off. (15 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-3/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-3/)

A password can be guessed, reused or read off the wire. An SSH key can't be any of those. You'll give client-a a key, install it on the server, then turn password logins off, so a password is no longer accepted at all.

### 1. Make a key on client-a

```
docker compose exec client-a ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
```

### 2. Install the public key on the server

`ssh-copy-id` copies the public half to the server. It asks for the password one last time, while password logins are still on.

```
docker compose exec client-a ssh-copy-id -o StrictHostKeyChecking=no netstate@10.10.20.10
```

### 3. Sign in with the key, no password

```
docker compose exec client-a ssh netstate@10.10.20.10 hostname
```

### 4. Turn password logins off

```
docker compose exec server sh -c "printf 'PasswordAuthentication no\nPubkeyAuthentication yes\nPermitRootLogin no\n' > /etc/ssh/sshd_config.d/lab.conf && pkill -HUP sshd"
```

### 5. Confirm a password is refused

```
docker compose exec client-a ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no netstate@10.10.20.10 true
```

## You should see

- Step 3: `server`. The key works, and it didn't ask for a password.
- Step 5: `Permission denied (publickey)`. The server won't take a password at all.

## What it means

The server now trusts a key that only client-a holds, and it accepts nothing else. This is what finally closes Phase 1's reuse: a password read off the wire, or guessed, is useless here, because the server stopped accepting passwords. The key never crosses the wire, so a capture can't catch it.

Next, each service gets its own login, then every Phase 1 leak is rechecked and shut.

---

[Previous: Move the web server to HTTPS](02-move-the-web-server-to-https.md) · [Next: A separate login for each service](04-a-separate-login-for-each-service.md)
