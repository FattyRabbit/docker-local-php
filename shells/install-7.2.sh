#!/bin/bash

source ../functions.sh

SERVICE_NAME=php-7.2
TARGET_PHPENV_VERSION=7.2.29

if service_exists $SERVICE_NAME; then
  ORIGINAL_PHPENV_VERSION=`phpenv global | xargs`
  PHP_BUILD_CONFIGURE_OPTS=--with-pear PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j4 phpenv install -v $TARGET_PHPENV_VERSION;
  phpenv global $TARGET_PHPENV_VERSION
  echo "extension = imagick.so" >> $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/php.ini && \
  echo 'xdebug.remote_enable = 1' >> $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/conf.d/xdebug.ini && \
  echo 'xdebug.remote_connect_back = 1' >> $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/conf.d/xdebug.ini && \
  echo 'xdebug.remote_port = 9001' >> $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/conf.d/xdebug.ini && \
  echo 'xdebug.max_nesting_level = 512' >> $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/conf.d/xdebug.ini && \
  echo 'xdebug.idekey = "PHPSTORM"' >> $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/conf.d/xdebug.ini

  # php-fpmの設定
  sed -i -e 's/^user = nobody/user = apache/g' $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/php-fpm.d/www.conf && \
  sed -i -e 's/^group = nobody/group = apache/g' $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/php-fpm.d/www.conf && \
  sed -i -e 's/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm'$SERVICE_NAME'.sock/g' $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/php-fpm.d/www.conf && \
  sed -i -e 's/^;listen.owner = nobody/listen.owner = apache/g' $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/php-fpm.d/www.conf && \
  sed -i -e 's/^;listen.group = nobody/listen.group = apache/g' $PHPENV_ROOT/versions/$TARGET_PHPENV_VERSION/etc/php-fpm.d/www.conf

  convertTemplate ./templates/php-fpm.service.tpl > "/etc/systemd/system/php-fpm${SERVICE_NAME}.service"
  convertTemplate ./templates/supervisord-fpm-service.ini.tpl > "/etc/supervisord.d/supervisord-fpm${SERVICE_NAME}-service.ini"

  phpenv global $ORIGINAL_PHPENV_VERSION
fi