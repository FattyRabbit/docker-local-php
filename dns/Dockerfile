FROM alpine:3.12
MAINTAINER kugyon.i <fatty.rabbit.dev@gmail.com>

# 外部からの受付とデフォルト値
ARG DOCKER_LOCAL_IP=127.0.0.1

# 変数を環境変数にセット
ENV DOCKER_LOCAL_IP=$DOCKER_LOCAL_IP

RUN apk --no-cache add dnsmasq

RUN mv /usr/sbin/dnsmasq /usr/sbin/dnsmasq-origin
COPY convert2hosts-dnsmasq /usr/sbin/dnsmasq
RUN chmod +x /usr/sbin/dnsmasq

EXPOSE 53 53/udp

ENTRYPOINT ["dnsmasq", "-k", "--log-facility=/var/log/dnsmasq.log"]
