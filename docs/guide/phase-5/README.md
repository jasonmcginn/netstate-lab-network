# Phase 5: traffic shaping

> Draft. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-5/)

A firewall doesn't only pass or block traffic; it can slow it, drop it, or cap it. This phase shapes the link and measures what the clients feel.

Everything so far has been pass or block. Real links are messier: they add delay, lose packets, and run out of bandwidth. The firewall can recreate all three on purpose, which is how you test how an application behaves on a bad connection without waiting for a bad day.

The tool is `tc` (traffic control) on the firewall. Two parts:

- **Bandwidth limiting** uses `tbf`, and it's shown here with real before-and-after numbers from the lab.
- **Delay and loss** use `netem`, a kernel feature not every host has. Where it's available (most desktop Linux and WSL2), the commands are here; the numbers are yours to read, because a measurement only means something from your own run.

**You need:** Phase 1 finished. `iperf3` (the throughput tool) is in the images.

| Step | Page | What you'll do |
|---|---|---|
| 0 | [Set up, and measure the baseline](00-set-up-and-measure-the-baseline.md) | Start a throughput test between the client and the server, and record the link's speed before any shaping. |
| 1 | [Cap the bandwidth](01-cap-the-bandwidth.md) | Limit the link to a slow speed and measure the drop, the one shaping this lab verifies with real numbers. |
| 2 | [Add delay and loss](02-add-delay-and-loss.md) | Use netem to make the link slow and lossy, and watch latency climb and packets disappear. |
| 3 | [Shape, measure, restore](03-shape-measure-restore.md) | Pull the phase together: the firewall can pass, block, or shape, and every change is one command away. |
