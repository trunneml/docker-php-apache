FROM php:5.6-apache
MAINTAINER Michael Trunner <michael@trunner.de>

RUN a2enmod rewrite expires

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libfreetype6-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr/ --enable-gd-native-ttf \
	&& docker-php-ext-install gd mysqli opcache mysql

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
# Max file upload
RUN { \
		echo 'upload_max_filesize = 24M'; \
		echo 'post_max_size = 24M'; \
	} > /usr/local/etc/php/conf.d/file-upload.ini

VOLUME /var/www/html
