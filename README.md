services:
  openvpn:
    image: igorvit/openvpn:1.1
    command: ["ovpn_run"]
    cap_add:
      - NET_ADMIN
    ports:
      - "31194:1194/udp"
    volumes:
      - openvpn-status:/tmp

  log-parser:
    image: igorvit/logparser:1.0
    command: ["/bin/sh", "-c", "/usr/local/bin/log_parser.sh"]
    environment:
      - CHECK_INTERVAL=5
      - LOG_FILE=/tmp/openvpn-status.log
      - PUSHGATEWAY_URL=http://pushgateway:9091
    volumes:
      - openvpn-status:/tmp

  pushgateway:
    image: prom/pushgateway:v1.9.0
    ports:
      - "9091:9091"
    volumes:
      - pushgateway-data:/tmp

  node-exporter:
    image: prom/node-exporter:v1.6.0
    ports:
      - "9100:9100"
    command:
      - "--no-collector.cpu"
      - "--no-collector.diskstats"
      - "--no-collector.filesystem"
      - "--no-collector.meminfo"
      - "--collector.netstat"
    restart: always

volumes:
  openvpn-status:
    driver: local
    driver_opts:
      type: none
      device: /tmp
      o: bind

  pushgateway-data:
    driver: local
    driver_opts:
      type: none
      device: /tmp
      o: bind
