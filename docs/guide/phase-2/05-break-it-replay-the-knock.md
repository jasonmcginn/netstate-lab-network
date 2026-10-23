# Step 5: Break it: replay the knock

**Goal:** Resend a captured knock from the outsider, and watch the door open for them too. (10 min)

> The full step-by-step for this page is being finalized. The result below is from the lab.

You knocked, and the door opened. But the knock is only a pattern of packets, with no secret inside it. Anyone who can watch the wire can copy it. Here the outsider, **client-b**, holds a capture of the authorized knock from step 2 and sends it again.

## What happens

The captured knock, resent from client-b, is the same four packets in the same order. The watcher can't tell it apart from the real thing, so it opens the door, this time for the outsider's address.

## You should see  _(from the lab)_

- The watcher's log records the outsider's knock and opens the door:
  `10.10.10.12: DOOR OPEN to ports 22,3389 for 60s`
- client-b reaches SSH during the open window.

## What it means

The knock carries no secret, so seeing it once is enough to repeat it. A pattern can be watched and copied, and a knock is only a pattern. This is the exact weakness that Single Packet Authorization closes in Phase 4.

> **✍️ To finish this page (Jason):**
> — write the step-by-step "Do" section above "What happens". Steps, in order:
> 1. Read the four knock packets out of captures\knock.pcap (ports and odd flags are in plain sight).
> 2. From client-b, send those same four packets to the server, in the same order (the knock command, or hping3).
> 3. From client-b, open SSH to the server to show the door opened.
> Lab facts (verified): sequence 4747 3043 3043 9034, flags FIN+PSH+URG; capture at captures\knock.pcap; knock tool shown in step 2.

---

[Previous: Timers](04-timers.md) · [Next: Break it: guessing gets banned](06-break-it-guessing-gets-banned.md)
