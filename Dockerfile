FROM alpine
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

RUN apk add --no-cache bash nginx php5-fpm php5-cli php5-json php5-soap \
    && apk add --no-cache --virtual build-dependencies wget unzip \
    && wget --no-check-certificate https://sourceforge.net/projects/phpvirtualbox/files/latest/download -O phpvirtualbox.zip \
    && unzip phpvirtualbox.zip -d phpvirtualbox \
    && mkdir -p /var/www \
    && mv -v phpvirtualbox/*/* /var/www/ \
    && rm phpvirtualbox.zip \
    && rm phpvirtualbox/ -R \
    && apk del build-dependencies \
    && echo "<?php return array(); ?>" > /var/www/config-servers.php \
    && echo "<?php return array(); ?>" > /var/www/config-override.php \
    && chown nobody:nobody -R /var/www \
    && sed -i 's/5.0-5/5.1-0/g' /var/www/endpoints/lib/config.php \
    && ln -s /var/www/endpoints/lib/vboxweb-5.0.wsdl /var/www/endpoints/lib/vboxweb-5.1.wsdl \
    && ln -s /var/www/endpoints/lib/vboxwebService-5.0.wsdl /var/www/endpoints/lib/vboxwebService-5.1.wsdl 

# config files
COPY config.php /var/www/config.php
COPY nginx.conf /etc/nginx/nginx.conf
COPY servers-from-env.php /servers-from-env.php

# expose only nginx HTTP port
EXPOSE 80

# write linked instances to config, then monitor all services
CMD php /servers-from-env.php && php-fpm && nginx
