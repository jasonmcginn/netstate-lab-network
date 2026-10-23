# Step 2: The replay test

**Goal:** Resend a captured SPA packet and confirm the door stays shut, the test the knock failed. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-2/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-2/)

In Phase 2, a captured knock, resent by the outsider, opened the door, because the knock is just a pattern with no secret. SPA is built to pass this exact test. Here you confirm it does.

### 1. Send an SPA packet and keep a copy

`-B` saves the exact packet that's sent.

```
docker compose exec client-a fwknop -A tcp/22 -N 10.10.20.10:22 -a 10.10.10.11 -D 10.10.10.1 -B /tmp/spa.pkt --key-base64-rijndael PASTE_KEY_BASE64 --key-base64-hmac PASTE_HMAC_KEY_BASE64
```

### 2. Wait for the door to close

The access lasts 30 seconds. Wait it out, then confirm SSH is shut again.

```
docker compose exec client-a sh -c "sleep 32; nmap -n -Pn -p 22 10.10.20.10"
```

### 3. Resend the exact same packet

```
docker compose exec client-a bash -c "cat /tmp/spa.pkt > /dev/udp/10.10.10.1/62201"
```

### 4. Check the door

```
docker compose exec client-a nmap -n -Pn -p 22 10.10.20.10
```

### 5. Confirm a fresh packet still works

```
docker compose exec client-a fwknop -A tcp/22 -N 10.10.20.10:22 -a 10.10.10.11 -D 10.10.10.1 --key-base64-rijndael PASTE_KEY_BASE64 --key-base64-hmac PASTE_HMAC_KEY_BASE64
```
```
docker compose exec client-a nmap -n -Pn -p 22 10.10.20.10
```

## You should see

- After the wait: `22/tcp filtered`. The door closed.
- After the replay: still `filtered`. The resent packet did nothing.
- After a fresh packet: `22/tcp open`. A new, valid packet still works.

## What it means

The firewall remembers every SPA packet it has accepted and refuses a repeat. A new packet is different every time, because it's encrypted with a changing value and signed, so a copied one is recognised and dropped. The knock failed this test; SPA passes it. That one difference is why SPA replaced knocking.

---

[Previous: One packet opens the door](01-one-packet-opens-the-door.md) · [Next: Knock vs SPA, side by side](03-knock-vs-spa-side-by-side.md)
