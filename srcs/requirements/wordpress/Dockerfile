FROM debian:bullseye

USER root

RUN apt update && apt install -y \
	wget \
	curl \
	sendmail \
	php-mysql \
	php-mysqli \
	mariadb-client \
	php \
	php-fpm && \
	mkdir -p /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

COPY ./tools/docker_entry.sh /usr/local/bin/

# Ensure the entry script is executable
RUN chmod +x /usr/local/bin/docker_entry.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker_entry.sh"]