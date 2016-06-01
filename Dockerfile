FROM alpine:latest

RUN echo 'http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

RUN apk --update add \
  nginx \
  php-fpm \
  php-pdo \
  php-json \
  php-openssl \
  php-mysql \
  php-pdo_mysql \
  php-mcrypt \
  php-sqlite3 \
  php-pdo_sqlite \
  php-ctype \
  php-zlib \
  php-curl \
  php-phar \
  php-xml \
  php-opcache \
  php-intl \
  php-bcmath \
  php-dom \
  php-xmlreader \
  php-xmlreader \
  php-xml \
  php-pear \
  php-xdebug \
  curl \
  supervisor \
  && rm -rf /var/cache/apk/*


RUN echo "zend_extension=xdebug.so" > /etc/php/conf.d/xdebug.ini \
      && echo "xdebug.remote_enable=on" >> /etc/php/conf.d/xdebug.ini \
      && echo "xdebug.remote_autostart=off" >> /etc/php/conf.d/xdebug.ini \
      && echo "xdebug.remote_host=vmhost.quidco.local" >> /etc/php/conf.d/xdebug.ini \
      && echo "xdebug.remote_port=9000" >> /etc/php/conf.d/xdebug.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php-fpm
RUN mkdir -p /var/log/supervisor

RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

ADD nginx-supervisor.ini /etc/supervisor.d/nginx-supervisor.ini

EXPOSE 80 9000

CMD ["/usr/bin/supervisord"]
