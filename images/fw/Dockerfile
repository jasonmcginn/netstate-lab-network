# The NetState Lab Network: firewall and router (fw)
# Sits on both networks (LAN and DMZ). Every packet between them crosses this container.
# Build context is the repo root, so the config/ folder can be copied in.
FROM debian:trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      iproute2 iptables iputils-ping traceroute tcpdump procps ulogd2 nfct conntrack fwknop-server \
 && rm -rf /var/lib/apt/lists/* \
 # one plugin path on every CPU type (amd64, arm64)
 && ln -s "$(dirname "$(find /usr/lib -name ulogd_inppkt_NFLOG.so | head -1)")" /usr/lib/ulogd

COPY config/fw/ulogd.conf /etc/ulogd.conf
# The Phase 2 knock watcher: installed, off until you start it
COPY images/fw/bin/knock-watcher /usr/local/bin/knock-watcher
COPY images/fw/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/knock-watcher

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
