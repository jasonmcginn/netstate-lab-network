# Step 0: Set up SPA next to the knock

**Goal:** Hide SSH again, then stand up fwknop on the firewall so a single encrypted packet can open the door. (15 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-0/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-0/)

Single Packet Authorization (SPA) does the knock's job with one packet instead of a sequence, and that packet is encrypted and signed so it can't be reused. The tool is `fwknop`: `fwknopd` runs on the firewall, `fwknop` on the client.

### 1. Rebuild and hide SSH

```
docker compose up -d --build
```
```
docker compose exec fw sh -c "iptables-restore < /lab/config/fw/phase1-rules.v4"
```
```
docker compose exec fw iptables -D FORWARD 5
```

SSH is now blocked for everyone, as at the start of Phase 2.

### 2. Make a key pair for SPA

```
docker compose exec client-a fwknop --key-gen
```

It prints a `KEY_BASE64` and an `HMAC_KEY_BASE64`. Copy both; you'll put them on the firewall and use them from the client.

### 3. Give the firewall the keys

Write them into the firewall's access file. Replace the two placeholders with the keys you just made.

```
docker compose exec fw sh -c 'cat > /etc/fwknop/access.conf <<CONF
SOURCE                 ANY
KEY_BASE64             PASTE_KEY_BASE64
HMAC_KEY_BASE64        PASTE_HMAC_KEY_BASE64
FW_ACCESS_TIMEOUT      30
REQUIRE_SOURCE_ADDRESS Y
CONF'
```
```
docker compose exec fw sh -c 'cp /lab/config/fw/fwknopd.conf /etc/fwknop/fwknopd.conf'
```

### 4. Start fwknopd

```
docker compose exec -d fw fwknopd
```
```
docker compose exec fw sh -c "ss -lun | grep 62201"
```

## You should see

- Two base64 keys from `--key-gen`.
- `fwknopd` listening on UDP `62201`.

## What it means

The firewall is now waiting for one specific, encrypted packet. Until it arrives, SSH is invisible, exactly as it was behind the knock. The difference is in what that packet is, which the next step shows.

---

[Phase steps](README.md) · [Next: One packet opens the door](01-one-packet-opens-the-door.md)
