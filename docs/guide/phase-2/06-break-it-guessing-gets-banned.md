# Step 6: Break it: guessing gets banned

**Goal:** Guess passwords from the outsider, and watch Fail2Ban lock them out. (10 min)

> The full step-by-step for this page is being finalized. The result below is from the lab.

The replay gets the outsider through the door, but not signed in. Now they try to guess the password. Fail2Ban watches the login log and bans an address after too many failures.

## What happens

After the door is open, repeated wrong passwords pile up in the server's login log. Fail2Ban is watching it, and once the failures cross the limit, it drops a firewall rule that blocks the outsider's address. The ban lifts itself after a set time.

## You should see  _(from the lab)_

- Fail2Ban's filter matches the failed logins (verified: 8 of 8 log lines).
- After the limit, the outsider's address shows in `Banned IP list`, and a reject rule appears in the server's firewall (`f2b-sshd`).
- The ban lifts on its own, and the address can reach SSH again.

## What it means

Fail2Ban stops password *guessing* by rate: too many wrong tries and you're locked out for a while. Hold that thought, because the next step gets in without a single wrong guess.

> **✍️ To finish this page (Jason):**
> — write the step-by-step "Do" above, and verify the auto-ban yourself:
> 1. Turn Fail2Ban on:  docker compose exec server fail2ban-client start
> 2. From client-b, open the door with a knock (step 5), then try SSH with wrong passwords, four times.
> 3. Check the ban:  docker compose exec server fail2ban-client status sshd  (then show the next attempt refused).
> VERIFY: the automatic ban firing from real failed logins is not yet confirmed (filter + a manual ban are). If the count stays flat, run: docker compose exec server fail2ban-regex /var/log/auth.log sshd-lab
> Settings: maxretry 4, bantime 20 min (lab runs a 2-minute ban). Config: config\server\fail2ban-lab.conf.

---

[Previous: Break it: replay the knock](05-break-it-replay-the-knock.md) · [Next: Break it: the reused password walks past](07-break-it-the-reused-password-walks-past.md)
