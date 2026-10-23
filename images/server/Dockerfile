# The NetState Lab Network: server (DMZ)
# One host, several services, like a real DMZ host:
#   web    :80  a login page over plain HTTP
#   telnet :23  plain-text remote login
#   ssh    :22  encrypted remote login
# All use the lab-only login from config/lab.env.
FROM debian:trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      iproute2 iputils-ping traceroute tcpdump procps \
      python3 openssh-server inetutils-telnetd openbsd-inetd iptables fail2ban xrdp openssl iperf3 \
 && rm -rf /var/lib/apt/lists/* \
 # Telnet runs from inetd; write the one service line ourselves
 && echo "telnet stream tcp nowait root $(command -v telnetd || ls /usr/sbin/*telnetd | head -1) telnetd" > /etc/inetd.conf \
 # SSH: password logins on (this lab teaches them); no root login
 && printf 'PasswordAuthentication yes\nPermitRootLogin no\n' > /etc/ssh/sshd_config.d/lab.conf \
 # Host keys are made at start-up, never baked into a public image
 && rm -f /etc/ssh/ssh_host_*

RUN mkdir -p /lab/tls /lab/web
COPY images/server/web/app.py /opt/web/app.py
# Fail2Ban's lab settings (installed now, switched on in Phase 2)
COPY config/server/fail2ban-lab.conf /etc/fail2ban/jail.d/lab.conf
COPY config/server/fail2ban-sshd-lab.conf /etc/fail2ban/filter.d/sshd-lab.conf
COPY images/server/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
