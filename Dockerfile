FROM php:7.4.24-apache
LABEL Dare=dare@zooto.io

#install zip, unzip extension, git, mysql-client
RUN apt-get update --fix-missing && apt-get install -y \
  default-mysql-client \
  git \
  unzip \
  zip \
  curl \
  wget
  
# Install docker php dependencies
RUN docker-php-ext-install pdo_mysql mysqli

# Add config files and binary file and enable webserver
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin
RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer |php && mv composer.phar /usr/local/bin/composer

WORKDIR /root/php-todo

RUN composer install --ignore-platform-reqs

RUN php artisan migrate
RUN php artisan key:generate
RUN php artisan db:seed
RUN php artisan serve --host:0.0.0.0

# Copy application source
COPY . /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 80

CMD ["start-apache"]
