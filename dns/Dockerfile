FROM andyshinn/dnsmasq
MAINTAINER kugyon.i <fatty.rabbit.75@gmail.com>

# 外部からの受付とデフォルト値
ARG DOCKER_LOCAL_IP=127.0.0.1

# 変数を環境変数にセット
ENV DOCKER_LOCAL_IP=$DOCKER_LOCAL_IP

RUN ls -a /etc
RUN mv /etc/dnsmasq /etc/dnsmasq-origin
COPY convert2hosts-dnsmasq /etc/dnsmasq
RUN chmod +x /etc/dnsmasq
RUN grep -l '$DOCKER_LOCAL_IP' /etc/hosts-dnsmasq | xargs sed -i -e "s/\$DOCKER_LOCAL_IP/$(echo $DOCKER_LOCAL_IP | sed -e 's/\//\\\//g')/g"

ENTRYPOINT ["dnsmasq", "-k", "--log-facility=/var/log/dnsmasq.log"]