# Step 7: Break it: the reused password walks past

**Goal:** Use the password leaked in Phase 1 to sign in cleanly, past Fail2Ban, because a correct login is not a failed one. (10 min)

> The full step-by-step for this page is being finalized. The result below is from the lab.

Fail2Ban bans wrong guesses. But the outsider doesn't need to guess: back in Phase 1 the same password crossed the wire in plain text (step 4). A correct login isn't a failed login, so nothing bans it.

## What happens

The outsider opens the door with a knock, then signs in with the known-good password read off the wire in Phase 1. It works on the first try. There is no failure for Fail2Ban to count, so no ban.

## You should see  _(from the lab)_

- The sign-in succeeds on the first attempt.
- Fail2Ban's failed count stays flat; the outsider is in, unbanned.

## What it means

This is the lesson that ties Phases 2, 3 and 4 together. A knock hides a door but keeps no secret. Fail2Ban stops guessing but not a stolen-but-correct password. The real fixes are unique credentials and keys (Phase 3) and an opener that can't be copied (Phase 4).

> **✍️ To finish this page (Jason):**
> — write the step-by-step "Do" above. Steps, in order:
> 1. From client-b, open the door with a knock.
> 2. Sign in to SSH with the known-good lab login (netstate / LabOnly-2026), read off the wire in Phase 1.
> 3. Show Fail2Ban's counter did not move: no failure, no ban.
> Knock and SSH commands are shown in steps 2 and 4.

---

[Previous: Break it: guessing gets banned](06-break-it-guessing-gets-banned.md) · [Next: Check your work, and save it as code](08-check-your-work-and-save-it-as-code.md)
