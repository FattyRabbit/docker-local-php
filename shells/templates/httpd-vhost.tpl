# httpの設定
<VirtualHost *:80>
    DocumentRoot ${DOCUMENT_ROOT}
    ServerName ${SERVER_NAME}

    ErrorLog /var/log/httpd/${SERVER_NAME}_error.log
    CustomLog /var/log/httpd/${SERVER_NAME}_requests.log common

    LogLevel rewrite:trace8

    <FilesMatch \.php$>
        SetHandler "proxy:fcgi://php${PHP_VERSION}-fpm:9000"
    </FilesMatch>

    <Directory "${ALLOW_DIRECTORY}">
        AllowOverride All
        Options +FollowSymLinks -Indexes
        DirectoryIndex index.php
    </Directory>
    DirectoryIndex index.php index.html
</VirtualHost>
# httpsの設定
<VirtualHost *:443>
    DocumentRoot ${DOCUMENT_ROOT}
    ServerName ${SERVER_NAME}

    ErrorLog /var/log/httpd/${SERVER_NAME}_error.log
    CustomLog /var/log/httpd/${SERVER_NAME}_requests.log common

    LogLevel rewrite:trace8

    SSLEngine on
    SSLCertificateFile /etc/ssl/private/server.crt
    SSLCertificateKeyFile /etc/ssl/private/server.key

    <FilesMatch \.php$>
        SetHandler "proxy:fcgi://php${PHP_VERSION}-fpm:9000"
    </FilesMatch>

    <Directory "${ALLOW_DIRECTORY}">
        AllowOverride All
        Options +FollowSymLinks -Indexes
        DirectoryIndex index.php
    </Directory>
    DirectoryIndex index.php index.html
</VirtualHost>
