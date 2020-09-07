FROM linuxserver/mysql
MAINTAINER kugyon.i <fatty.rabbit.dev@gmail.com>

# TimeZoneの設定のため
RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql && \
    mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql

# TimeZoneの設定
RUN apt-get update && \
    apt-get install -y tzdata

RUN rm -rf /var/lib/apt/lists/* && \
    echo "$TZ" > /etc/timezone && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

EXPOSE 3306