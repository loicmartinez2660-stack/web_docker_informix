# Docker + PHP 7.4 + Informix Drivers for PDO
You like web servers ? You like Docker ? You like Informix (is that even possible) ? \
Well there you have it, a fully configurable web server in docker, to connect to a informix database

## .ENV
**Those variable are needed**
- DATABASE_ADDRESS
- DATABASE_PORT
- SERVER_NAME
- DATABASE_NAME
- USER_NAME
- USER_PASSWORD

## Informations
- PhpMyAdmin isn't supported with informix database
- PHP 7.4 is the latest version i could make it work with


## Web files
Every files will be shared from the /src -> /var/www/html inside the web container

## Ports
Only the Port 80 is opened because there is no support for HTTPS yet


# Todo
HTTPS support
