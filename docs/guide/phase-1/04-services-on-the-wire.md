# Step 4: Services on the wire

**Goal:** Sign in to the server three ways, web, Telnet and SSH, and see which passwords can be read off the wire. (15 min)

> Draft. Example wording, to reword. Also on the site: [https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-4/](https://www.netstatedata.ca/guide/netstate-lab-network/phase-1/step-4/)

The server runs three services, all with the same lab-only login. It's public on purpose; never reuse it anywhere real.

| User | Password |
|---|---|
| `netstate` | `LabOnly-2026` |

### 1. See what's open

nmap knocks on the server's ports and lists the ones that answer.

```
docker compose exec client-a nmap -n 10.10.20.10
```

### 2. Start a capture of the three services

```
docker compose exec -d fw tcpdump -i any -nn -U --immediate-mode -w /captures/step4.pcap "tcp port 80 or tcp port 23 or tcp port 22"
```

### 3. Sign in to the web page

This sends the login form the way a browser would, over plain HTTP. The page answers `Signed in.`

```
docker compose exec client-a curl -s -d "username=netstate&password=LabOnly-2026" http://10.10.20.10/login
```

### 4. Sign in with Telnet

Type the username and password when asked, run `whoami`, then type `exit`.

```
docker compose exec client-a telnet 10.10.20.10
```

### 5. Sign in with SSH

The first time, type `yes` to trust the server's key. Then the password, `whoami`, and `exit`.

```
docker compose exec client-a ssh netstate@10.10.20.10
```

### 6. Stop the capture and look for the password

```
docker compose exec fw pkill tcpdump
```
```
docker compose exec fw sh -c "tcpdump -r /captures/step4.pcap -nn -A 2>/dev/null | grep -a password="
```

### 7. Read the Telnet login in Wireshark

Telnet sends each key you press as its own packet, so it's easiest to read in Wireshark, which puts them back together. Open `captures\step4.pcap` from the lab folder, type `telnet` in the filter bar, then right-click any packet and choose **Follow > TCP Stream**.

<!-- screenshot: step4-wireshark-telnet.png -->

## You should see

- nmap: ports **22** (ssh), **23** (telnet) and **80** (http) open.
- The web search: `username=netstate&password=LabOnly-2026`, in plain text (twice, because the capture sees it on both sides of fw).
- Wireshark: your Telnet username, password and every command you typed.
- SSH: nothing readable at all.

## What it means

The firewall saw all three logins, and two of them it could read. The web form and Telnet send everything as typed, so anyone who can capture the traffic, on a firewall, a switch or shared Wi-Fi, gets the password. SSH carries the same login encrypted. HTTPS does the same for the web page; that comes in Phase 3.

Next, step 5 shows why it matters that all three use the same password.

---

[Previous: Watch the traffic: two views](03-two-views.md) · [Next: One password, three doors](05-one-password-three-doors.md)
