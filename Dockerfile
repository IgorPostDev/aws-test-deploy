FROM php:8.2-fpm
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libonig-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip pdo pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
COPY . .
RUN mkdir -p /var/www/storage \
    && chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

RUN composer install --no-dev --optimize-autoloader
CMD ["php-fpm"]
EXPOSE 9000
