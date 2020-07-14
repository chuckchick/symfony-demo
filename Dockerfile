FROM debian:10-slim

RUN apt-get update && \
  apt-get install -y \
  php \
  php-ctype \
  php-iconv \
  php-json \
  php-simplexml \ 
  php-tokenizer \ 
  php-pdo-pgsql \
  php-mbstring \
  zip \
  unzip \
  apache2

COPY apache2-foreground /usr/local/bin
RUN chmod a+x /usr/local/bin/apache2-foreground
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

COPY . /app
RUN chown -R www-data:www-data /app


EXPOSE 80

STOPSIGNAL SIGWINCH

CMD ["/usr/local/bin/apache2-foreground"]

