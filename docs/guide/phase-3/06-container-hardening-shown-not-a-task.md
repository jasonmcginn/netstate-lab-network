# Step 6: Container hardening (shown, not a task)

**Goal:** Understand the hardening a production build would add, and where this lab stops on purpose. (5 min read)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-6/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/step-6/)

The fixes so far are about what the services do. Hardening is about what a container is allowed to do if a service is ever broken into. This page is a read, not a task: the lab's containers are kept deliberately open so the lessons can change firewall rules and routes.

In production, these machines would be tightened in ways the lessons don't need:

- **Run as a non-root user.** The lab runs as root so you can edit iptables and routes by hand. A production service runs as an unprivileged user, so a break-in doesn't start with full control.
- **Drop Linux capabilities.** The firewall here holds `NET_ADMIN` because managing the firewall is its job. A normal service would drop every capability it doesn't use.
- **Read-only root filesystem.** A service that never needs to write to its own files runs with the filesystem read-only, so nothing can be dropped onto it.
- **Resource limits.** Caps on memory and CPU, so one container can't starve the host.
- **A smaller base image.** Fewer packages installed means less to attack and less to patch.

## What it means

Hardening is the layer that assumes a service will eventually be broken into, and limits the damage when it is. The lab leaves it off so the networking lessons stay hands-on, and names it here so the gap is deliberate, not hidden. In a production build of this network, every item above would be on.

---

[Previous: Recheck the leaks](05-recheck-the-leaks.md) · [Next: Check your work, and save it as code](07-check-your-work-and-save-it-as-code.md)
