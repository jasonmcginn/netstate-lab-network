# Phase 2: Legacy Port Knocking Test

> Draft. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-2/)

A legacy remote-access technique: hide SSH and RDP behind a port knock, so they are invisible until you send a secret pattern of packets. Here you rebuild it, watch it work, then break it.

A **port knock** keeps a service hidden until you send a secret pattern of packets. This one is a faithful recreation of a legacy design: the firewall logs odd-looking packets, a watcher reads the log, and when one address sends the right sequence in time, SSH and RDP open for that address only, for a few minutes.

Then you break it. Knocking is one layer on top of a deny-all firewall, not a lock on its own, and this phase shows exactly where it falls short.

**You need:** Phase 1 finished, or at least its answer key loaded (step 0 does that).

| Step | Page | What you'll do |
|---|---|---|
| 0 | [Start from Phase 1's end](00-start-from-phase-1s-end.md) | Rebuild the lab with the Phase 2 tools, load Phase 1's finished firewall, and read the knock's settings. |
| 1 | [Hide](01-hide.md) | Close SSH for everyone, so the server's remote access disappears from the network. |
| 2 | [Knock](02-knock.md) | Turn on the knock, send it from client-a, and watch the door open for client-a only. |
| 3 | [One packet by hand](03-one-packet-by-hand.md) | Craft one knock packet yourself, and see exactly what makes it different from normal traffic. |
| 4 | [Timers](04-timers.md) | Watch the three timers work: the door closes, a session already open stays up, and an idle one is dropped. |
| 5 | [Break it: replay the knock](05-break-it-replay-the-knock.md) | Resend a captured knock from the outsider, and watch the door open for them too. |
| 6 | [Break it: guessing gets banned](06-break-it-guessing-gets-banned.md) | Guess passwords from the outsider, and watch Fail2Ban lock them out. |
| 7 | [Break it: the reused password walks past](07-break-it-the-reused-password-walks-past.md) | Use the password leaked in Phase 1 to sign in cleanly, past Fail2Ban, because a correct login is not a failed one. |
| 8 | [Check your work, and save it as code](08-check-your-work-and-save-it-as-code.md) | Confirm the knock hides the doors, then save the firewall rules so Phase 2 starts the same way every time. |
| next | Phase 3: fix the leaks (coming) | |
