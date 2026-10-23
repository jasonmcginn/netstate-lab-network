# Step 1: One packet opens the door

**Goal:** Open SSH with a single SPA packet, and see how little crosses the wire compared with the knock. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-1/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-1/)

### 1. Confirm SSH is shut

```
docker compose exec client-a nmap -n -Pn -p 22 10.10.20.10
```

### 2. Send one SPA packet

Use the keys from step 0. `-N` names the service to open (the server's SSH), `-D` is the firewall.

```
docker compose exec client-a fwknop -A tcp/22 -N 10.10.20.10:22 -a 10.10.10.11 -D 10.10.10.1 --key-base64-rijndael PASTE_KEY_BASE64 --key-base64-hmac PASTE_HMAC_KEY_BASE64
```

### 3. Sign in

```
docker compose exec client-a ssh netstate@10.10.20.10
```

### 4. See what the firewall opened

```
docker compose exec fw iptables -S FWKNOP_FORWARD
```

## You should see

- The scan before: `22/tcp filtered`.
- After the one packet: SSH connects.
- `FWKNOP_FORWARD` holds a short-lived rule: `ACCEPT ... 10.10.10.11 ... dport 22 ... _exp_<time>`. It disappears on its own after 30 seconds.

## What it means

The knock was several packets with odd flags, sent in order. SPA is one UDP packet, and its contents are encrypted and signed. On the wire, an onlooker sees a single packet of random-looking data going to the firewall, with no hint of what it asks for or whether it worked. The door opens for the sender's address only, then closes itself.

---

[Previous: Set up SPA next to the knock](00-set-up-spa-next-to-the-knock.md) · [Next: The replay test](02-the-replay-test.md)
