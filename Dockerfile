FROM php:7.4.2-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
git \
vim \
zip \
less \
libsqlite3-dev \
net-tools \
openssh-client \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev \
libxml2-dev \
cron \
msmtp \
&& docker-php-ext-install -j$(nproc) gd soap \
&& apt-get -y autoremove \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

COPY msmtprc /etc/msmtprc

RUN echo "Europe/London" > /etc/timezone \
&& rm /etc/localtime \
&& dpkg-reconfigure -f noninteractive tzdata

RUN echo "date.timezone = Europe/London" >> $PHP_INI_DIR/php.ini \
&& echo "error_reporting = 30711" >> $PHP_INI_DIR/php.ini \
&& echo "log_errors = On" >> $PHP_INI_DIR/php.ini \
&& echo "display_errors = Off" >> $PHP_INI_DIR/php.ini \
&& echo "memory_limit = 512M" >> $PHP_INI_DIR/php.ini \
&& echo "sendmail_path = /usr/bin/msmtp -t" >> $PHP_INI_DIR/php.ini

CMD [ "apache2-foreground" ]