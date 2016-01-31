FROM busybox
MAINTAINER Jon Jagger

RUN mkdir -p /var/www/cyber-dojo/test
COPY test /var/www/cyber-dojo/test
WORKDIR /var/www/cyber-dojo/test
RUN chown -R www-data:www-data .
RUN chmod -R +r .

VOLUME ["/var/www/cyber-dojo/test"]
CMD ["not runnable - a data container"]
