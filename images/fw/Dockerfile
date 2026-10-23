# The NetState Lab Network: firewall and router (fw)
# Sits on both networks (LAN and DMZ). Every packet between them crosses this container.
# Build context is the repo root, so the config/ folder can be copied in.
FROM debian:trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      iproute2 iptables iputils-ping traceroute tcpdump procps ulogd2 \
 && rm -rf /var/lib/apt/lists/* \
 # one plugin path on every CPU type (amd64, arm64)
 && ln -s "$(dirname "$(find /usr/lib -name ulogd_inppkt_NFLOG.so | head -1)")" /usr/lib/ulogd

COPY config/fw/ulogd.conf /etc/ulogd.conf
COPY images/fw/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
