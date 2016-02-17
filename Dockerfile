FROM alpine
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

RUN apk add --no-cache bash nginx php-fpm php-cli php-json php-soap \
	&& apk add --no-cache --virtual build-dependencies wget unzip \
	&& wget --no-check-certificate https://sourceforge.net/projects/phpvirtualbox/files/latest/download -O phpvirtualbox.zip \
	&& unzip phpvirtualbox.zip -d phpvirtualbox \
	&& mkdir -p /var/www \
	&& mv -v phpvirtualbox/*/* /var/www/ \
	&& rm phpvirtualbox.zip \
	&& rm phpvirtualbox/ -R \
	&& apk del build-dependencies

# config files
COPY config.php /var/www/config.php
COPY nginx.conf /etc/nginx/nginx.conf
COPY servers-from-env.php /servers-from-env.php

# dummy config-servers.php
RUN echo "<?php return array(); ?>" > /var/www/config-servers.php \
	&& chown nobody:nobody -R /var/www

# expose only nginx HTTP port
EXPOSE 80

# write linked instances to config, then monitor all services
CMD php /servers-from-env.php && php-fpm && nginx
