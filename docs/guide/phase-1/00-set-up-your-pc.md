# Step 0: Set up your PC

**Goal:** Docker running on Windows, the lab downloaded into its own folder, and started for the first time. (30 min, once)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-0/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-0/)

The lab is four small Linux machines that run inside Docker. Docker Desktop runs them on Windows using WSL, Windows' built-in Linux layer. You set this up once.

**You need:** Windows 11, or Windows 10 22H2, with 8 GB of memory, and the latest Docker Desktop (update it if you already have it). Docker Desktop is free for personal use, learning and small businesses; larger companies need a paid Docker subscription.

### 1. Open a terminal

Press the Windows key, type `Terminal`, and open **Terminal** (on Windows 10 without it, open **Windows PowerShell** instead). Every command in this guide is typed here. Copy one box at a time, paste it, and press Enter.

Don't use **PowerShell ISE**. It isn't a real terminal: it shows Docker's normal messages as red errors and freezes when you step inside a machine.

<!-- screenshot: setup-01-powershell.png -->

### 2. Check virtualization is on

Docker needs your CPU's virtualization feature. Open Task Manager (Ctrl + Shift + Esc), go to **Performance > CPU**, and look for **Virtualization: Enabled**. If it says Disabled, turn it on in your PC's BIOS settings (often called Intel VT-x or AMD-V).

<!-- screenshot: setup-02-virtualization.png -->

### 3. Install or update WSL

This installs WSL if it's missing, then brings it up to date. An old WSL is the most common reason Docker Desktop won't start.

```
wsl --install --no-distribution
```
```
wsl --update
```

If Windows asks you to restart, restart and reopen PowerShell.

### 4. Install Docker Desktop

```
winget install --id Docker.DockerDesktop -e
```

Start **Docker Desktop** from the Start menu and accept the terms. Signing in to a Docker account is optional. Wait until the bottom-left corner says **Engine running**.

<!-- screenshot: setup-06-docker-running.png -->

### 5. Check Docker's version

The lab uses a Docker feature added in version 28.

```
docker version --format "{{.Server.Version}}"
```

You should see a number starting with **28** or higher.

### 6. Install Git and make a folder for the lab

Git downloads the lab and lets you pull updates later. Close and reopen PowerShell after installing it.

```
winget install --id Git.Git -e
```
```
New-Item -ItemType Directory -Path C:\Labs -Force
```

### 7. Download the lab

```
Set-Location C:\Labs
```
```
git clone https://github.com/jasonmcginn/netstate-lab-network.git
```
```
Set-Location C:\Labs\netstate-lab-network
```

From now on, run every command from this folder.

### 8. Build and start the lab

The first run builds the four machines from the files in `images`, so it takes a few minutes. Later starts take seconds.

```
docker compose up -d --build
```

## You should see

At the end, the images built and four machines started:

```
Image netstate-lab/fw:dev Built
Container netstate-lab-fw-1 Started
Container netstate-lab-server-1 Started
Container netstate-lab-client-a-1 Started
Container netstate-lab-client-b-1 Started
```

In Docker Desktop, under **Containers**, a group called **netstate-lab** with four containers.

<!-- screenshot: setup-09-containers.png -->

## Stuck?

| Problem | Fix |
|---|---|
| Docker Desktop won't start, or says WSL is too old | Run `wsl --update`, then `wsl --shutdown`, then start Docker Desktop again |
| `docker` or `git` is not recognized | Close and reopen PowerShell after installing |
| Red text with `NativeCommandError` | You're in PowerShell ISE. Close it and use Terminal or Windows PowerShell |
| A command freezes when you step inside a machine (`bash`, `telnet`, `ssh`) | Same cause: PowerShell ISE. Close the window and use Terminal. If Docker stays stuck, run `wsl --shutdown` and start Docker Desktop again |
| `Cannot connect to the Docker daemon` | Docker Desktop isn't running yet. Start it and wait for **Engine running** |
| Version below 28 | In Docker Desktop: **Settings > Software updates** |

A worked example of tracking one of these down: [the frozen shell](https://www.netstatedata.ca/guide/netstate-lab-network/troubleshooting-frozen-shell/).

---

[Phase 1 steps](README.md) · [Next: step 1](01-start-the-lab.md)
