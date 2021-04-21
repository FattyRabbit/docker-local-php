FROM linuxserver/mysql
MAINTAINER kugyon.i <fatty.rabbit.dev@gmail.com>

# apt-get -y update
# apt-get -y upgrade
# apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
# apt list | grep -i mariadb-server
# apt install mariadb-server-10.4 -y

# TimeZoneの設定
RUN apt-get update
RUN apt-get install -y tzdata

RUN rm -rf /var/lib/apt/lists/* && \
    echo "$TZ" > /etc/timezone && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

EXPOSE 3306