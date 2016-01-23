FROM ubuntu:latest
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

ENV phpVBoxVersion 5.0-5

RUN apt-get update \
	&& DEBIAN_FRONTEND="noninteractive" \
	apt-get install -y --no-install-recommends nginx php5-fpm supervisor wget unzip php5-cli \
	&& apt-get --purge autoremove \
	&& rm -rf /var/lib/apt/lists/*

# install phpvirtualbox
RUN wget http://sourceforge.net/projects/phpvirtualbox/files/phpvirtualbox-${phpVBoxVersion}.zip/download -O phpvirtualbox-${phpVBoxVersion}.zip \
	&& unzip phpvirtualbox-${phpVBoxVersion}.zip \
	&& mkdir -p /var/www \
	&& mv -v phpvirtualbox-${phpVBoxVersion}/* /var/www/ \
	&& rm phpvirtualbox-${phpVBoxVersion}.zip \
	&& rm phpvirtualbox-${phpVBoxVersion}/ -R
	

ADD config.php /var/www/config.php
ADD phpvirtualbox.nginx.conf /etc/nginx/sites-available/phpvirtualbox
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD servers-from-env.php /servers-from-env.php

RUN echo "<?php return array(); ?>" > /var/www/config-servers.php \
	&& chown www-data:www-data -R /var/www \
	&& ln -s /etc/nginx/sites-available/phpvirtualbox /etc/nginx/sites-enabled/phpvirtualbox \
	&& rm /etc/nginx/sites-enabled/default

# expose only nginx HTTP port
EXPOSE 80

# write linked instances to config, then monitor all services
CMD php /servers-from-env.php && supervisord -c /etc/supervisor/conf.d/supervisord.conf
