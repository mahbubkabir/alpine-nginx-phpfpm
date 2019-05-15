FROM alpine:latest

# Install required packages
RUN apk upgrade --no-cache && \
 apk add --no-cache bind-tools libcap ca-certificates openssl openssh bash diffutils git socat strace jq nano curl rsync mysql-client \
 nginx \
 php7-bcmath \
 php7-bz2 \
 php7-calendar \
 php7-ctype \
 php7-curl \
 php7-dom \
 php7-exif \
 php7-fileinfo \
 php7-fpm \
 php7-ftp \
 php7-gd \
 php7-gettext \
 php7-gmp \
 php7-iconv \
 php7-intl \
 php7-json \
 php7-mbstring \
 php7-mcrypt \
 php7-mysqli \
 php7-opcache \
 php7-openssl \
 php7-pcntl \
 php7-pdo_mysql \
 php7-pdo_sqlite \
 php7-phar \
 php7-posix \
 php7-session \
 php7-simplexml \
 php7-soap \
 php7-sockets \
 php7-sqlite3 \
 php7-tokenizer \
 php7-wddx \
 php7-xdebug \
 php7-xml \
 php7-xmlreader \
 php7-xmlrpc \
 php7-xmlwriter \
 php7-xsl \
 php7-zip \
 php7-zlib \
 curl \
 supervisor && \
 rm -rf /etc/php7/conf.d/xdebug.ini && \
 ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm


RUN echo "zend_extension=xdebug.so" > /etc/php7/conf.d/xdebug.ini \
      && echo "xdebug.remote_enable=on" >> /etc/php7/conf.d/xdebug.ini \
      && echo "xdebug.remote_autostart=on" >> /etc/php7/conf.d/xdebug.ini \
      && echo "xdebug.remote_host=local.mk.io" >> /etc/php7/conf.d/xdebug.ini \
      && echo "xdebug.remote_port=9000" >> /etc/php7/conf.d/xdebug.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /etc/nginx/conf.d
ADD nginx.conf /etc/nginx/nginx.conf
ADD nginx-default.conf /etc/nginx/conf.d/default.conf

ADD nginx-supervisor.ini /etc/supervisor.d/nginx-supervisor.ini

RUN mkdir /app

EXPOSE 80 9000

CMD ["/usr/bin/supervisord"]

WORKDIR /app