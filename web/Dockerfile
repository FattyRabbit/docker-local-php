FROM centos:7
MAINTAINER kugyon.i <fatty.rabbit.75@gmail.com>

# Declare Arguments
ARG SERVER_NAME=local

# TimeZoneの設定
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "LC_ALL=ja_JP.UTF-8" >> /etc/environment && \
    echo "LC_CTYPE=ja_JP.UTF-8" >> /etc/environment && \
    echo "LANG=ja_JP.UTF-8" >> /etc/environment
RUN localedef -f UTF-8 -i ja_JP /usr/lib/locale/ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP

# yumアップデート
RUN yum -y update
RUN yum -y remove httpd httpd.x86_64 httpd-tools.x86_64

# install leatest apache2.4.*
#RUN yum install -y epel-release
#RUN	yum -y install https://repo.ius.io/ius-release-el7.rpm
#RUN	sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/ius.repo && \
#	sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
#RUN yum --enablerepo=epel -y install nghttp2 && \
#	yum -y install epel-release && \
#	yum -y install mailcap system-logos && \
RUN	yum -y install openssl wget && \
    # Installing packages required for httpd 2.4.41
#	wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/b/brotli-1.0.7-5.el7.x86_64.rpm && \
#	rpm -Uvh brotli-1.0.7-5.el7.x86_64.rpm && \
#	yum -y install brotli && \
	yum -y install httpd mod_ssl && \
	yum clean all
RUN sed -i -e "s|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|" /etc/httpd/conf.modules.d/00-mpm.conf && \
	sed -i -e "s|#LoadModule mpm_event_module modules/mod_mpm_event.so|LoadModule mpm_event_module modules/mod_mpm_event.so|" /etc/httpd/conf.modules.d/00-mpm.conf
RUN sed -i -e "s|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|" /etc/httpd/conf/httpd.conf && \
	sed -i -e "s|#LoadModule mpm_event_module modules/mod_mpm_event.so|LoadModule mpm_event_module modules/mod_mpm_event.so|" /etc/httpd/conf/httpd.conf
# make SSL server certificate
RUN mkdir -p /etc/ssl/private && \
	openssl req -new -newkey rsa:2048 -nodes -out /etc/ssl/private/server.csr -keyout /etc/ssl/private/server.key -subj "/C=JP/ST=TOKYO/L=SHIBUYA/O=Wiz Inc./OU=/CN=*.${SERVER_NAME}" && \
	openssl x509 -days 36500 -req -signkey /etc/ssl/private/server.key -in /etc/ssl/private/server.csr -out /etc/ssl/private/server.crt

COPY conf.d/vhosts.conf /etc/httpd/conf.d/vhosts.conf

# dockre can not use systemd without permission, apahce is started with httpd
#CMD ["/usr/sbin/httpd", "-k", "start"]
RUN systemctl enable httpd