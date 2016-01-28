FROM cyberdojofoundation/rails
MAINTAINER Jon Jagger <jon@jaggersoft.com>

COPY app       /var/www/cyber-dojo
COPY caches    /var/www/cyber-dojo
COPY config    /var/www/cyber-dojo
COPY db        /var/www/cyber-dojo
COPY doc       /var/www/cyber-dojo
COPY lib       /var/www/cyber-dojo
COPY log       /var/www/cyber-dojo
COPY public    /var/www/cyber-dojo
COPY script    /var/www/cyber-dojo
COPY spec      /var/www/cyber-dojo
COPY tmp       /var/www/cyber-dojo
COPY Rakefile  /var/www/cyber-dojo
COPY config.ru /var/www/cyber-dojo

CMD [ "bash", "-c", "rails server" ]
