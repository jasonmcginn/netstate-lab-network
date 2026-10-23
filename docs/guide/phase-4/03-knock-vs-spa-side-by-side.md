# Step 3: Knock vs SPA, side by side

**Goal:** See the two methods against the same tests, from the lab's own results. (5 min read)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-3/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-4/step-3/)

Both methods hide a service until a secret arrives. Here they are against the same tests you've now run on both.

| Test | Legacy knock (Phase 2) | SPA (fwknop) |
|---|---|---|
| Outsider scans the port | Nothing there | Nothing there |
| Authorized client opens it | Yes, a sequence of packets | Yes, one packet |
| What crosses the wire | Several packets with odd flags, in order | One packet of encrypted data |
| A captured copy, resent | Opens the door | Rejected, door stays shut |
| Is the request readable | The ports and order are in plain sight | Encrypted; nothing is readable |

## What it means

Knocking and SPA solve the same problem, hiding a service behind a secret. The knock's secret is a pattern, and a pattern can be watched and copied. SPA's secret is a key, and the packet it sends is encrypted and signed, so watching it reveals nothing and copying it gets nowhere. SPA is the knock's idea, done so that seeing it doesn't break it.

---

[Previous: The replay test](02-the-replay-test.md) · [Next: WireGuard, for comparison (a read)](04-wireguard-for-comparison-a-read.md)
