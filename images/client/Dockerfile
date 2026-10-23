# The NetState Lab Network: client (LAN)
# A user's desk: tools to reach the server's services, and to look at the wire.
#   curl    web requests        telnet   plain-text remote login
#   ssh     encrypted login     nmap     what is listening (used from Phase 1)
FROM debian:trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      iproute2 iputils-ping traceroute tcpdump procps \
      curl inetutils-telnet openssh-client nmap iptables \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
