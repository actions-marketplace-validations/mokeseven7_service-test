# Container image that runs your code
FROM ubuntu:21.04
ENV DEBIAN_FRONTEND noninteractive

# Set working directory
WORKDIR /var/www


# ADD REPOS
RUN sudo apt install software-properties-common
RUN sudo add-apt-repository ppa:ondrej/php
RUN sudo apt update

#INSTALL OS DEPS
RUN sudo apt-get install -y gnupg nxinx curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2

# Install dependencies
RUN sudo apt update && sudo apt install -y php8.0-fpm    
RUN sudo apt install php8.0-{bz2,curl,intl,mysql,readline,xml}

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create an app user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port 9000 and start php-fpm server
EXPOSE 8000 9000 9001

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["entrypoint"]
