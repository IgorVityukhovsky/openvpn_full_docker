FROM alpine:3.20

RUN apk add --no-cache bash curl
ADD https://raw.githubusercontent.com/IgorVityukhovsky/openvpn_full_docker/refs/heads/main/log_parser.sh /usr/local/bin/log_parser.sh
RUN chmod +x /usr/local/bin/log_parser.sh

CMD ["/usr/local/bin/log_parser.sh"]