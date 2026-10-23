# Step 7: Open for purpose

**Goal:** Open only what each task needs: web for everyone, SSH for client-a only, Telnet for no one. Then see why rule order matters. (15 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-7/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-7/)

The policy for this network:

| Service | Who | Why |
|---|---|---|
| Ping | Anyone on the LAN | Troubleshooting |
| Web (80) | Anyone on the LAN | The DMZ serves the public |
| SSH (22) | client-a only | The authorized admin |
| Telnet (23) | No one | It sends passwords in plain text (step 4) |

Each rule goes in **before** the drop-log rule, so you insert it at a position number instead of adding it at the end.

### 1. Allow ping (rule 3)

```
docker compose exec fw iptables -I FORWARD 3 -i lan -o dmz -p icmp --icmp-type echo-request -j ACCEPT
```

### 2. Allow web for everyone (rule 4)

```
docker compose exec fw iptables -I FORWARD 4 -i lan -o dmz -p tcp --dport 80 -j ACCEPT
```

### 3. Allow SSH for client-a only (rule 5)

`-s 10.10.10.11` limits the rule to client-a's address.

```
docker compose exec fw iptables -I FORWARD 5 -i lan -o dmz -s 10.10.10.11 -p tcp --dport 22 -j ACCEPT
```

There's no rule for Telnet. Not allowing it is how you block it.

### 4. Check the rules

```
docker compose exec fw iptables -L FORWARD -n --line-numbers
```

### 5. Check each client's view

The check script tests what this client can and can't reach against the policy above.

```
docker compose exec client-a sh /lab/tests/check-phase1.sh
```
```
docker compose exec client-b sh /lab/tests/check-phase1.sh
```

And what the outsider sees when it scans:

```
docker compose exec client-b nmap -n -Pn -p 22,23,80 10.10.20.10
```

### 6. See why order matters

Block client-b completely, at the top (rule 1), then try the web page from client-b:

```
docker compose exec fw iptables -I FORWARD 1 -s 10.10.10.12 -j DROP
```
```
docker compose exec client-b curl -s -m 5 -o /dev/null -w "%{http_code}\n" http://10.10.20.10/
```

Now remove that rule, and try again:

```
docker compose exec fw iptables -D FORWARD 1
```
```
docker compose exec client-b curl -s -m 5 -o /dev/null -w "%{http_code}\n" http://10.10.20.10/
```

## You should see

The rules:

```
1    NFLOG    ...   ctstate NEW nflog-prefix FW-NEW
2    ACCEPT   ...   ctstate RELATED,ESTABLISHED
3    ACCEPT   ...   icmptype 8
4    ACCEPT   ...   tcp dpt:80
5    ACCEPT   ...   10.10.10.11   tcp dpt:22
6    NFLOG    ...   nflog-prefix FW-DROP
```

- Both checks end with `6 passed, 0 failed`.
- nmap from client-b: `80/tcp open`, and `22` and `23` **filtered** (no answer at all).
- The order test: `000` while the block is at the top, `200` once it's gone.

## What it means

Each service is open to exactly who needs it. To the outsider, SSH and Telnet don't refuse the connection, they simply never answer, which tells a scanner as little as possible.

The order test shows the rule every firewall follows: **first match wins**. The block at the top stopped client-b before it ever reached the web rule below it. When a firewall doesn't do what you expect, read its rules top to bottom.

---

[Previous: Lock it down](06-lock-it-down.md) · [Next: The way around](08-the-way-around.md)
