FROM cyberdojofoundation/rails
MAINTAINER Jon Jagger <jon@jaggersoft.com>

COPY app       /var/www/cyber-dojo/app
COPY caches    /var/www/cyber-dojo/caches
COPY config    /var/www/cyber-dojo/config
COPY lib       /var/www/cyber-dojo/lib
COPY script    /var/www/cyber-dojo/script
COPY config.ru /var/www/cyber-dojo

RUN mkdir /var/www/cyber-dojo/tmp
RUN mkdir /var/www/cyber-dojo/log

CMD [ "bash", "-c", "rails server" ]
