FROM alpine:latest
WORKDIR /php
RUN apk update && apk add bash && apk add openrc \
&& apk add php7-fpm php7-mcrypt php7-soap php7-openssl \
&& apk add php7-gmp php7-pdo_odbc php7-json php7-dom \
&& apk add php7-pdo php7-zip php7-mysqli php7-sqlite3 \
&& apk add php7-apcu php7-pdo_pgsql php7-bcmath php7-gd \
&& apk add php7-odbc php7-pdo_mysql php7-pdo_sqlite \
&& apk add php7-gettext php7-xmlreader php7-xmlrpc \
&& apk add php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype sed \
&& sed -i "s|listen = 127.0.0.1:9000|listen = 172.15.0.3:9000|g" /etc/php7/php-fpm.d/www.conf
COPY php7.sh /etc/profile.d/php7.sh
EXPOSE 9000
CMD ["php-fpm7", "--nodaemonize"]
