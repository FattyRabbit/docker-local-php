SHOW VARIABLES LIKE 'validate_password%';
set global validate_password.length=6;
set global validate_password.policy=LOW;

CREATE USER root@'172.16.0.%' IDENTIFIED BY '12345678';
GRANT ALL PRIVILEGES ON *.* TO root@'172.16.0.%';