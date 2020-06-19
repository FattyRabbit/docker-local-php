FROM centos:7
MAINTAINER kugyon.i <fatty.rabbit.75@gmail.com>

# Declare Arguments
ARG SERVER_NAME=example.com:80

# Set the environment of anyenv
ENV ANYENV_HOME /opt/anyenv
ENV ANYENV_ENV  $ANYENV_HOME/envs
ENV ANYENV_DEFINITION_ROOT $ANYENV_HOME/share/anyenv-install/
# Set the environment of phpenv
ENV PHPENV_ROOT $ANYENV_ENV/phpenv

# TimeZoneの設定
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "LC_ALL=ja_JP.UTF-8" >> /etc/environment && \
    echo "LC_CTYPE=ja_JP.UTF-8" >> /etc/environment && \
    echo "LANG=ja_JP.UTF-8" >> /etc/environment
RUN localedef -f UTF-8 -i ja_JP /usr/lib/locale/ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP

# yumアップデート
RUN yum -y update

# remiリポジトリの登録
RUN yum install -y epel-release
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# apacheのインストール：v2.4.6
RUN yum install -y httpd
# SSHDのインストール
RUN yum install -y openssh-server
# sudoのインストール
RUN yum install -y sudo
# PHPの依存するパッケージをインストール
RUN yum install -y gcc gcc-c++ wget make file php-fpm unzip git rsync automake libcurl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
# supervisordのインストール
RUN yum install -y supervisor
# postfixをインストール
RUN yum install -y postfix mailx
# syslogの追加
RUN yum install -y rsyslog

# postfixの設定
RUN cp /etc/postfix/main.cf /etc/postfix/main.cf.bak
RUN sed -ri 's/inet_interfaces = localhost/inet_interfaces = 127.0.0.1/' /etc/postfix/main.cf

# apacheの設定
RUN rm -rf /etc/httpd/conf.d/welcome.conf
RUN cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
RUN sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/    AllowOverride None/    AllowOverride All/' /etc/httpd/conf/httpd.conf && \
    sed -ri '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/    Options Indexes FollowSymLinks/    Options Indexes FollowSymLinks Includes/' /etc/httpd/conf/httpd.conf && \
    sed -ri 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/' /etc/httpd/conf/httpd.conf && \
    sed -i -e "s/\#ServerName www.example.com:80/ServerName ${SERVER_NAME}/g" /etc/httpd/conf/httpd.conf

# SSHDの設定
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# rootユーザーのパスワード変更
RUN echo 'root:12345678' | chpasswd

# system wide
# anyenvを入れる
RUN git clone https://github.com/riywo/anyenv $ANYENV_HOME
RUN git clone https://github.com/anyenv/anyenv-install $ANYENV_DEFINITION_ROOT
RUN echo 'export PATH="'$ANYENV_HOME'/bin:$PATH"' >> /etc/profile.d/anyenv.sh && \
    echo 'export ANYENV_ROOT="'$ANYENV_HOME'"'  >> /etc/profile.d/anyenv.sh && \
    echo 'export ANYENV_DEFINITION_ROOT="'$ANYENV_HOME'/share/anyenv-install"' >> /etc/profile.d/anyenv.sh && \
    chmod 755 /etc/profile.d/anyenv.sh

ENV PATH $ANYENV_HOME/bin:$PATH
ENV ANYENV_ROOT $ANYENV_HOME
ENV ANYENV_DEFINITION_ROOT $ANYENV_HOME/share/anyenv-install

# phpenvを入れる
RUN anyenv install phpenv

# phpのビルド環境を整える
RUN yum install -y libxml2-devel bison bison-devel libjpeg-devel libpng-devel readline-devel libmcrypt libmcrypt-devel libxslt-devel httpd-devel enchant-devel libXpm libXpm-devel freetype-devel t1lib t1lib-devel gmp-devel libicu-devel net-snmp net-snmp-devel bzip2 bzip2-devel
RUN yum --enablerepo=epel install -y libtidy-devel re2c

# cmakeのインストール
RUN wget https://cmake.org/files/v3.12/cmake-3.12.0-Linux-x86_64.tar.gz -O cmake-3.12.0-Linux-x86_64.tar.gz && \
    tar zxvf cmake-3.12.0-Linux-x86_64.tar.gz && \
    rm -rf /usr/share/aclocal && \
    rm -rf /usr/share/applications && \
    rm -rf /usr/share/mime && \
    mkdir -p /usr/bin && \
    cp -r cmake-3.12.0-Linux-x86_64/bin/* /usr/bin/ && \
    mkdir -p /usr/share && \
    cp -r cmake-3.12.0-Linux-x86_64/share/* /usr/share/ && \
    rm -rf cmake-3.12.0-Linux-x86_64

# libzipのインストール
RUN yum remove -y libzip libzip-devel
RUN mkdir /tmp/libzip && \
    cd /tmp/libzip && \
    wget https://libzip.org/download/libzip-1.4.0.tar.gz -O libzip-1.4.0.tar.gz && \
    tar zxf libzip-1.4.0.tar.gz && \
    cd libzip-1.4.0 && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/libzip/1.4.0 && \
    make && \
    make install

# ERROR:configure: error: off_t undefined; check your library configuration
# 以下を削除:Mysqlを利用してない場合
# 参考：http://www.8wave.net/ldconfig.html
# vi /etc/ld.so.conf
RUN echo '/usr/local/lib' >> /etc/ld.so.conf
RUN echo '/usr/lib ' >> /etc/ld.so.conf
RUN ldconfig

# php7.3をインストル
ENV PATH $ANYENV_ENV/phpenv/bin:$ANYENV_ENV/phpenv/shims:$PATH
RUN PHP_BUILD_CONFIGURE_OPTS="--with-pear --with-mcrypt --with-tidy" PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j4 PKG_CONFIG_PATH="/opt/libzip/1.4.0/lib/pkgconfig" phpenv install -v 7.3snapshot

# linkを作成
RUN ln -s /opt/anyenv/envs/phpenv/shims/php /bin/php
RUN ln -s /opt/anyenv/envs/phpenv/shims/pecl /bin/pecl

# imageMagickをインストール
RUN yum install -y ImageMagick-devel ImageMagick

# php環境を設定
# 7.3snapshot
RUN phpenv global 7.3snapshot && \
    phpenv rehash && \
    yes '' | pecl install imagick
RUN echo "extension = imagick.so" >> $PHPENV_ROOT/versions/7.3snapshot/etc/php.ini && \
    echo 'xdebug.remote_enable = 1' >> $PHPENV_ROOT/versions/7.3snapshot/etc/conf.d/xdebug.ini && \
    echo 'xdebug.remote_connect_back = 1' >> $PHPENV_ROOT/versions/7.3snapshot/etc/conf.d/xdebug.ini && \
    echo 'xdebug.remote_port = 9001' >> $PHPENV_ROOT/versions/7.3snapshot/etc/conf.d/xdebug.ini && \
    echo 'xdebug.max_nesting_level = 512' >> $PHPENV_ROOT/versions/7.3snapshot/etc/conf.d/xdebug.ini && \
    echo 'xdebug.idekey = "PHPSTORM"' >> $PHPENV_ROOT/versions/7.3snapshot/etc/conf.d/xdebug.ini

# php-fpmの設定
RUN sed -i -e 's/^user = nobody/user = apache/g' $PHPENV_ROOT/versions/7.3snapshot/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^group = nobody/group = apache/g' $PHPENV_ROOT/versions/7.3snapshot/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm7.3.sock/g' $PHPENV_ROOT/versions/7.3snapshot/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^;listen.owner = nobody/listen.owner = apache/g' $PHPENV_ROOT/versions/7.3snapshot/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^;listen.group = nobody/listen.group = apache/g' $PHPENV_ROOT/versions/7.3snapshot/etc/php-fpm.d/www.conf

# composerのインストール
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# php-fpmサービスを追加
COPY php-fpm*.service /etc/systemd/system/
RUN grep -l '$PHPENV_ROOT' /etc/systemd/system/php-fpm*.service | xargs sed -i -e "s/\$PHPENV_ROOT/$(echo $PHPENV_ROOT | sed -e 's/\//\\\//g')/g"

# サンプルのVirtualhostの設定ファイルを追加
RUN mkdir /var/www/sample-7.3
RUN touch /etc/httpd/conf.d/vhosts.conf && \
   echo 'Include conf.d/extra/7.3_virtual.conf' >> /etc/httpd/conf.d/vhosts.conf

# 自動開始
RUN systemctl enable postfix rsyslog supervisord httpd

# supervisordの設定
RUN touch /etc/supervisord.conf
RUN sed -i -e 's/nodaemon=false/nodaemon=true/g' /etc/supervisord.conf
COPY supervisord-fpm*-service.ini /etc/supervisord.d/
RUN touch /etc/supervisord.d/supervisord-ssh.ini && \
    echo '[program:sshd]' >> /etc/supervisord.d/supervisord-ssh.ini && \
    echo 'command=systemctl start sshd' >> /etc/supervisord.d/supervisord-ssh.ini
RUN touch /etc/supervisord.d/supervisord-httpd.ini && \
    echo '[program:apache]' >> /etc/supervisord.d/supervisord-httpd.ini && \
    echo 'command=systemctl start httpd' >> /etc/supervisord.d/supervisord-httpd.ini
RUN touch /etc/supervisord.d/supervisord-postfix.ini && \
    echo '[program:postfix]' >> /etc/supervisord.d/supervisord-postfix.ini && \
    echo 'command=systemctl start postfix' >> /etc/supervisord.d/supervisord-postfix.ini

EXPOSE 22 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]