# The NetState Lab Network

A firewall between a LAN and a DMZ, on one PC. Built to show what crosses the wire, and why. Part of [netstatedata.ca](https://www.netstatedata.ca).

> **Status:** all five phases written. Phase 1, 3, 4 and 5 complete; Phase 2 has steps 0 to 4, with its "break it" pages in progress.

```
   LAN 10.10.10.0/24                     DMZ 10.10.20.0/24

   client-a  .11  ──┐                ┌──  server  .10   web, telnet, ssh
                    ├── fw .1 / .1 ──┤
   client-b  .12  ──┘                
```

Every packet between the LAN and the DMZ crosses fw. Nothing reaches the internet.

## Start here

**[The step-by-step guide](docs/guide/README.md)**, also on [netstatedata.ca](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/). New to Docker? Begin with [step 0: set up your PC](docs/guide/phase-1/00-set-up-your-pc.md).

## Quick start

Needs Docker 28 or newer.

```
docker compose up -d --build
docker compose exec client-a sh /lab/tests/check-routing.sh
docker compose down
```

## License

MIT. See [LICENSE](LICENSE).
