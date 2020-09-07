FROM andyshinn/dnsmasq
MAINTAINER kugyon.i <fatty.rabbit.75@gmail.com>

# 外部からの受付とデフォルト値
ARG DOCKER_LOCAL_IP=127.0.0.1

# 変数を環境変数にセット
ENV DOCKER_LOCAL_IP=$DOCKER_LOCAL_IP

RUN mv /usr/sbin/dnsmasq /etc/dnsmasq-origin
COPY convert2hosts-dnsmasq /usr/sbin/dnsmasq
RUN chmod +x /usr/sbin/dnsmasq

ENTRYPOINT ["dnsmasq", "-k", "--log-facility=/var/log/dnsmasq.log"]