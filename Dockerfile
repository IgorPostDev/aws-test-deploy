FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zlib1g-dev \
    libssl-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl soap \
    && pecl install grpc protobuf redis \
    && docker-php-ext-enable grpc protobuf redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .
RUN composer install

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

CMD ["php-fpm"]

EXPOSE 9000
