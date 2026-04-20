FROM php:8.5-cli

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install intl \
    zip \
    xml

RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

COPY ./docker/php/php.dev.ini "$PHP_INI_DIR/php.ini"

# Install composer
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# Install Symfony CLI
COPY --link \
    --from=ghcr.io/symfony-cli/symfony-cli:latest \
    /usr/local/bin/symfony /usr/local/bin/symfony

# Create a non-root user to run the application
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g $GROUP_ID appuser \
    && useradd -u $USER_ID -g $GROUP_ID -ms /bin/bash appuser


COPY . .

RUN chmod +x /app/init.sh

USER appuser

EXPOSE 8000

ENTRYPOINT [ "/app/init.sh" ]