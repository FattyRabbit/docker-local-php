# It's not recommended to modify this file in-place, because it
# will be overwritten during upgrades.  If you want to customize,
# the best way is to use the "systemctl edit" command.

[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/var/run/php-fpm${SERVICE_VERSION}.pid
ExecStart=$PHPENV_ROOT/versions/${TARGET_PHPENV_VERSION}/sbin/php-fpm -F
ExecReload=/bin/kill -USR2 $MAINPID

[Install]
WantedBy=multi-user.target