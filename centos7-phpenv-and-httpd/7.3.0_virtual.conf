<VirtualHost *:80>
     DocumentRoot /var/www/sample-7.3.0
     ServerName 730.$SERVER_NAME

     ErrorLog /var/log/httpd/730.$SERVER_NAME_error.log
     CustomLog /var/log/httpd/730.$SERVER_NAME_requests.log common

     LogLevel rewrite:trace8

     <FilesMatch \.php$>
         SetHandler "proxy:unix:/var/run/php-fpm7.3.0.sock|fcgi://localhost"
     </FilesMatch>

     <Directory "/var/www/sample-7.3.0">
        AllowOverride All
        Options +FollowSymLinks -Indexes
    </Directory>
</VirtualHost>