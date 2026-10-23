# Phase 3: fix the leaks

> Draft. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-3/)

Every weakness Phase 1 exposed gets closed: Telnet gone, the web login encrypted, SSH on keys instead of passwords. Then the old leaks are checked again, and they're shut.

Phase 1 showed the leaks: a login readable over Telnet, a password readable over plain HTTP, and one password that opened every door. This phase closes each one, by hand, and then confirms it's closed.

Nothing here is baked into the lab. You do the hardening, the same way you'd do it on a real host.

**You need:** Phase 1 finished (its firewall loaded). Phase 2 isn't required.

| Step | Page | What you'll do |
|---|---|---|
| 0 | [Start from Phase 1's end](00-start-from-phase-1s-end.md) | Rebuild the lab, load Phase 1's firewall, and confirm the leaks are still open so the fixes have a clear before and after. |
| 1 | [Remove Telnet](01-remove-telnet.md) | Take the plain-text Telnet service off the server for good. |
| 2 | [Move the web server to HTTPS](02-move-the-web-server-to-https.md) | Give the web server a certificate, serve the login over HTTPS, and confirm the password no longer shows on the wire. |
| 3 | [SSH on keys, not passwords](03-ssh-on-keys-not-passwords.md) | Give client-a an SSH key, trust it on the server, and turn password logins off. |
| 4 | [A separate login for each service](04-a-separate-login-for-each-service.md) | Give the web its own login, so the account that opens the web is not the account that opens the shell. |
| 5 | [Recheck the leaks](05-recheck-the-leaks.md) | Go back to the three Phase 1 leaks and confirm each one is now closed. |
| 6 | [Container hardening (shown, not a task)](06-container-hardening-shown-not-a-task.md) | Understand the hardening a production build would add, and where this lab stops on purpose. |
| 7 | [Check your work, and save it as code](07-check-your-work-and-save-it-as-code.md) | Confirm every leak is closed, then save the firewall rules so Phase 3 starts the same way every time. |
| next | Phase 4: modern remote access (coming) | |
