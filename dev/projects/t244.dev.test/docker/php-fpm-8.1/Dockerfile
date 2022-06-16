ARG TAG
FROM php:${TAG}-fpm
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    wget \
    unzip \
     libfreetype6-dev \
     libjpeg62-turbo-dev \
     libmagickwand-dev \
     libmemcached-dev \
     libpng-dev \
     libwebp-dev \
     libxml2-dev \
     libxpm-dev \
     libxslt-dev \
     libzip-dev \
     zlib1g-dev
RUN docker-php-ext-install \
     bcmath \
     bz2 \
     exif \
     gettext \
     mysqli \
     opcache \
     pcntl \
     pdo_mysql \
     soap \
     sockets \
     xsl \
     zip
RUN docker-php-ext-configure intl \
&& docker-php-ext-install intl \
&& pecl install imagick \
&& docker-php-ext-enable imagick \
&& pecl install redis \
&& docker-php-ext-enable redis \
&& pecl install memcached \
&& docker-php-ext-enable memcached \
&& docker-php-ext-configure gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
&& docker-php-ext-install gd \
&& pecl install xdebug-3.1.5 \
&& docker-php-ext-enable xdebug \
&& apt-get clean
RUN rm -rf /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/* \
       /var/log/lastlog \
       /var/log/faillog
ARG PHP_COMPOSER_VERSION
ARG USER_ID
ARG GROUP_ID
RUN usermod -u ${USER_ID} www-data \
&& groupmod -g ${GROUP_ID} www-data \
&& mkdir ~www-data/public \
&& mkdir ~www-data/.composer \
&& chown -R www-data:www-data ~www-data \
&& cd ~ \
&& EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')" \
&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" \
&& if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then >&2 echo 'ERROR: Invalid installer checksum' && rm composer-setup.php && exit 1; fi \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=${PHP_COMPOSER_VERSION} --quiet \
&& rm composer-setup.php
RUN wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -O /usr/local/bin/mhsendmail \
&& chmod 0755 /usr/local/bin/mhsendmail

USER www-data
WORKDIR /var/www/public
CMD ["php-fpm"]