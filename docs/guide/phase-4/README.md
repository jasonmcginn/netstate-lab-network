# Phase 4: modern remote access

> Draft. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/)

The legacy knock had one weakness: anyone who saw it could replay it. This phase puts it next to Single Packet Authorization, which can't be replayed, and measures the difference in the lab.

Phase 2 hid SSH behind a port knock and then broke it: the knock carries no secret, so a captured copy, resent, opens the door for anyone. This phase keeps the same test and tries a modern answer, Single Packet Authorization (SPA), which fixes exactly that.

WireGuard, a third approach, is covered as a read at the end; it needs kernel support this container lab doesn't have, so its behaviour is described, not run here.

Every result on these pages comes from the lab. Nothing is claimed that wasn't measured.

**You need:** Phase 2 finished (the knock in place). The SPA tool, `fwknop`, is already in the images.

| Step | Page | What you'll do |
|---|---|---|
| 0 | [Set up SPA next to the knock](00-set-up-spa-next-to-the-knock.md) | Hide SSH again, then stand up fwknop on the firewall so a single encrypted packet can open the door. |
| 1 | [One packet opens the door](01-one-packet-opens-the-door.md) | Open SSH with a single SPA packet, and see how little crosses the wire compared with the knock. |
| 2 | [The replay test](02-the-replay-test.md) | Resend a captured SPA packet and confirm the door stays shut, the test the knock failed. |
| 3 | [Knock vs SPA, side by side](03-knock-vs-spa-side-by-side.md) | See the two methods against the same tests, from the lab's own results. |
| 4 | [WireGuard, for comparison (a read)](04-wireguard-for-comparison-a-read.md) | Understand a third approach the lab doesn't run: a VPN that answers nothing it doesn't recognise. |
| next | Phase 5: traffic shaping (coming) | |
