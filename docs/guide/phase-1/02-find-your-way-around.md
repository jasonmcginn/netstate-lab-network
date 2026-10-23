# Step 2: Find your way around

**Goal:** See what's running, step inside a machine, and start, stop or reset the lab. (10 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-2/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-2/)

```
   LAN 10.10.10.0/24                     DMZ 10.10.20.0/24

   client-a  .11  ──┐                ┌──  server  .10
                    ├── fw .1 / .1 ──┤
   client-b  .12  ──┘
```

client-a is the authorized user, client-b is the outsider, and the server is the public-facing host.

### 1. See what's running

```
docker compose ps
```

All four machines should show as **Up**.

### 2. Step inside a machine

This opens a shell on client-a, as if you'd sat down at its keyboard. The prompt changes to `root@client-a:/#`. (If it freezes, you're probably in PowerShell ISE: use Terminal instead. [How this was tracked down.](https://www.netstatedata.ca/guide/netstate-lab-network/troubleshooting-frozen-shell/))

```
docker compose exec client-a bash
```

Look at its address and its routes:

```
ip -br addr
```
```
ip route
```

Then leave and go back to PowerShell:

```
exit
```

### 3. Run one command without stepping inside

Most of this guide works this way: `docker compose exec`, the machine's name, then the command.

```
docker compose exec fw ip -br addr
```

### 4. Read a machine's start-up log

```
docker compose logs server
```

## You should see

Inside client-a, one address on the LAN and one route to the DMZ, through fw:

```
eth0@if10        UP             10.10.10.11/24
10.10.20.0/24 via 10.10.10.1 dev eth0
```

On fw, one network card on each side, named after the network it's on:

```
dmz@if8          UP             10.10.20.1/24
lan@if9          UP             10.10.10.1/24
```

The numbers after `@if` will be different on your PC.

<!-- screenshot: nav-02-inside-client-a.png -->

## Handy commands

| To | Run |
|---|---|
| Stop the lab, keep everything | `docker compose stop` |
| Start it again | `docker compose start` |
| Reset every machine to a clean start | `docker compose down`, then `docker compose up -d` |
| Remove the lab completely | See [below](#remove-the-lab-completely) |
| Rebuild after the lab files change | `docker compose up -d --build` |

Docker Desktop does the same: open **Containers > netstate-lab**, click a machine, and use the **Logs** or **Exec** tab.

## Remove the lab completely

When you're done with the lab, this removes every trace of it from your PC. Run the first command from the lab folder.

**1. Remove the machines, their networks and the lab's images:**

```
docker compose down --rmi all --volumes --remove-orphans
```

**2. Remove the Debian base image the lab was built from.** Skip this if other projects on your PC use it; Docker will say so and leave it alone.

```
docker image rm debian:trixie-slim
```

**3. Clear Docker's build cache.** This frees the space used while building. It clears the cache for every project, which only means other projects build a little slower next time.

```
docker builder prune -f
```

**4. Delete the lab folder,** including your captures and logs:

```
Set-Location C:\Labs
```
```
Remove-Item -Recurse -Force C:\Labs\netstate-lab-network
```

To check nothing is left, these should list nothing from the lab:

```
docker ps -a --filter "name=netstate-lab"
```
```
docker images "netstate-lab/*"
```
```
docker network ls --filter "name=netstate-lab"
```

Docker Desktop, WSL and Git stay installed. Uninstall them from **Windows Settings > Apps** if you no longer need them.

---

[Previous: Prove the path](01-start-the-lab.md) · [Next: Watch the traffic: two views](03-two-views.md)
