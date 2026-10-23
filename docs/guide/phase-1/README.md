# Phase 1: firewall and protocols on the wire

> Draft. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/)

Start with an open network, watch what crosses the firewall, then lock it down and find the way around it.

Every step is one page: what to do, the exact commands to copy, what you should see, and what it means. Work through them in order; each one builds on the last.

**You need:** a Windows 10 or 11 PC with 8 GB of memory. No network gear, no cloud account. Commands are typed in Windows Terminal or PowerShell, not PowerShell ISE.

| Step | Page | What you'll do |
|---|---|---|
| 0 | [Set up your PC](00-set-up-your-pc.md) | Docker running on Windows, the lab downloaded into its own folder, and started for the first time. |
| 1 | [Prove the path](01-start-the-lab.md) | Prove every packet between the LAN and the DMZ goes through the firewall, and only the firewall. |
| 2 | [Find your way around](02-find-your-way-around.md) | See what's running, step inside a machine, and start, stop or reset the lab. |
| 3 | [Watch the traffic: two views](03-two-views.md) | See the same traffic two ways: the firewall's log and a packet capture. |
| 4 | [Services on the wire](04-services-on-the-wire.md) | Sign in to the server three ways, web, Telnet and SSH, and see which passwords can be read off the wire. |
| 5 | [One password, three doors](05-one-password-three-doors.md) | Use the password read off the wire to walk through the one door that was encrypted, and see what the logs make of it. |
| 6 | [Lock it down](06-lock-it-down.md) | Switch the firewall from allow-everything to deny-everything, watch it all break, and read the drops in the log. |
| 7 | [Open for purpose](07-open-for-purpose.md) | Open only what each task needs: web for everyone, SSH for client-a only, Telnet for no one. Then see why rule order matters. |
| 8 | [The way around](08-the-way-around.md) | Give traffic a second path that skips the firewall, and learn the three signs that give it away. |
| 9 | [Host firewalls](09-host-firewalls.md) | Find which firewall is blocking: fw, the server's own, or the client's own. Two planted faults, one method. |
| 10 | [Check your work, and save it as code](10-check-your-work.md) | Prove Phase 1's policy is in place, save the rules to a file, compare them with the answer key, and load them back. |
| next | Phase 2: Legacy Port Knocking Test (coming) | |
