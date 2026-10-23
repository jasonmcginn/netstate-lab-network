# Step 1: Hide

**Goal:** Close SSH for everyone, so the server's remote access disappears from the network. (5 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/step-1/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/step-1/)

In Phase 1, client-a had a permanent rule for SSH. A permanent rule is a permanent target: anyone who can reach client-a's address can try it. The legacy design removes it.

### 1. Find the SSH rule

```
docker compose exec fw iptables -L FORWARD -n --line-numbers
```

It's rule 5: `ACCEPT ... 10.10.10.11 ... tcp dpt:22`.

### 2. Delete it

```
docker compose exec fw iptables -D FORWARD 5
```

RDP never had a rule, so it's already closed.

### 3. Scan from both clients

```
docker compose exec client-a nmap -n -Pn -p 22,3389 10.10.20.10
```
```
docker compose exec client-b nmap -n -Pn -p 22,3389 10.10.20.10
```

## You should see

From both clients:

```
22/tcp   filtered ssh
3389/tcp filtered ms-wbt-server
```

## What it means

**Filtered** means the firewall gave no answer at all. To a scanner, there's nothing there to attack. But client-a, the authorized user, is locked out too. The knock is how it gets back in.

---

[Previous: Start from Phase 1's end](00-start-from-phase-1s-end.md) · [Next: Knock](02-knock.md)
