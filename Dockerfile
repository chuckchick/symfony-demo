# multistage build - first run composer to get all dependencies
FROM composer:latest as composer

COPY composer.* /app/

ENV APP_ENV prod

RUN APP_ENV=prod composer install --prefer-dist --no-dev --no-scripts --no-suggest --no-interaction --optimize-autoloader

COPY . /app

RUN APP_ENV=prod composer dump-autoload --no-dev --optimize --classmap-authoritative

#FROM debian:10-slim
FROM php:7.3-apache

RUN apt-get update && \
  apt-get install -y \
#  git \
#  zip \
#  unzip \
  libpq-dev && \
#  curl && \
  apt-get clean

RUN docker-php-ext-install pdo pdo_pgsql


#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#COPY apache2-foreground /usr/local/bin
#RUN chmod a+x /usr/local/bin/apache2-foreground
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

COPY . /app
COPY --from=composer /app/vendor /app/vendor

RUN chown -R www-data:www-data /app

WORKDIR /app


#RUN echo "error_log /dev/stderr" >> /etc/php//7.3/apache2/conf.d/00-log.ini

EXPOSE 80
ENV APP_ENV prod

#STOPSIGNAL SIGWINCH

#CMD ["/usr/local/bin/apache2-foreground"]

