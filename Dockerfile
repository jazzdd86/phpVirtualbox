FROM alpine
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

RUN apk update && apk add --no-cache bash nginx php7-fpm php7-cli php7-common php7-json php7-soap php7-simplexml php7-session \
    && apk add --no-cache --virtual build-dependencies wget unzip \
    && wget --no-check-certificate https://github.com/phpvirtualbox/phpvirtualbox/archive/5.2-1.zip -O phpvirtualbox.zip \
    && unzip phpvirtualbox.zip -d phpvirtualbox \
    && mkdir -p /var/www \
    && mv -v phpvirtualbox/*/* /var/www/ \
    && rm phpvirtualbox.zip \
    && rm phpvirtualbox/ -R \
    && apk del build-dependencies \
    && echo "<?php return array(); ?>" > /var/www/config-servers.php \
    && echo "<?php return array(); ?>" > /var/www/config-override.php \
    && chown nobody:nobody -R /var/www

# config files
COPY config.php /var/www/config.php
COPY nginx.conf /etc/nginx/nginx.conf
COPY servers-from-env.php /servers-from-env.php

# expose only nginx HTTP port
EXPOSE 80

# write linked instances to config, then monitor all services
CMD php7 /servers-from-env.php && php-fpm7 && nginx
