FROM igorvit/openvpn:1.0
COPY openvpn_docker_udp/ /etc/openvpn/

RUN chmod -R 600 /etc/openvpn && \
    chown -R root:root /etc/openvpn

CMD ["ovpn_run"]
