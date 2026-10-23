# Step 4: A separate login for each service

**Goal:** Give the web its own login, so the account that opens the web is not the account that opens the shell. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-4/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-4/)

In Phase 1, one password opened everything (step 5). Keys fixed the shell in step 3; now the web gets its own login too, so a leak of one is a leak of one, not of all.

### 1. Check the web still takes the shared login

```
docker compose exec client-a curl -sk -o /dev/null -w "%{http_code}\n" -d "username=netstate&password=LabOnly-2026" https://10.10.20.10/login
```

`200`: the shared account still works here.

### 2. Give the web its own credential

Write a web-only login to the server. It's separate from the `netstate` system account, which is now key-only.

```
docker compose exec server sh -c 'echo "webadmin:Web-Only-7788" > /lab/web/users'
```

### 3. Try both logins again

```
docker compose exec client-a curl -sk -o /dev/null -w "shared  %{http_code}\n" -d "username=netstate&password=LabOnly-2026" https://10.10.20.10/login
```
```
docker compose exec client-a curl -sk -o /dev/null -w "web-only %{http_code}\n" -d "username=webadmin&password=Web-Only-7788" https://10.10.20.10/login
```

## You should see

- The shared login: `401`. It no longer opens the web.
- The web-only login: `200`.

## What it means

The web now has an account of its own, with no bearing on the Linux login. The shell takes a key and no password; the web takes its own credential and nothing else. Reusing one to reach the other, which walked straight in during Phase 1, now gets nowhere. Each door has its own key.

---

[Previous: SSH on keys, not passwords](03-ssh-on-keys-not-passwords.md) · [Next: Recheck the leaks](05-recheck-the-leaks.md)
