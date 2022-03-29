FROM php:8.1.4-apache

WORKDIR /var/www/html

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Update Apache configuration
ENV APACHE_DOCUMENT_ROOT /var/www/html/web
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite

# Install packages
RUN apt-get update && apt-get install -y
RUN apt-get install curl
RUN apt-get install wget
RUN apt-get install unzip
RUN apt-get install default-mysql-client -y
RUN apt-get install zlib1g-dev
RUN apt-get install libpng-dev -y

# Install php ext
RUN docker-php-ext-install gd mysqli pdo pdo_mysql

# Enable PHP OPCODE CACHING
RUN docker-php-ext-install opcache
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"
ADD docker/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Install Drush
RUN composer global require drush/drush && \
    composer global update

# Copy project dependencies and install
COPY composer.json .
COPY composer.lock .
RUN composer install

# Copy project files
COPY . .