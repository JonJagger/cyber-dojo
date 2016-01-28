FROM cyberdojofoundation/rails
MAINTAINER Jon Jagger <jon@jaggersoft.com>

COPY app       /var/www/cyber-dojo/app
COPY caches    /var/www/cyber-dojo/caches
COPY config    /var/www/cyber-dojo/config
COPY db        /var/www/cyber-dojo/db
COPY doc       /var/www/cyber-dojo/doc
COPY lib       /var/www/cyber-dojo/lib
COPY log       /var/www/cyber-dojo/log
COPY public    /var/www/cyber-dojo/public
COPY script    /var/www/cyber-dojo/script
COPY spec      /var/www/cyber-dojo/spec
COPY tmp       /var/www/cyber-dojo/tmp
COPY Rakefile  /var/www/cyber-dojo
COPY config.ru /var/www/cyber-dojo

CMD [ "bash", "-c", "rails server" ]
