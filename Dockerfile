FROM alpine

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
  apk --no-cache --no-progress add bash curl ip6tables iptables openvpn \
              shadow tini tzdata && \
  addgroup -S vpn && \
  rm -rf /tmp/*

COPY openvpn.sh /usr/bin/
RUN chmod +x /usr/bin/openvpn.sh

HEALTHCHECK --interval=60s --timeout=15s --start-period=180s \
           CMD curl -LSs 'https://api.ipify.org' || kill 1

VOLUME ["/vpn"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/openvpn.sh"]
