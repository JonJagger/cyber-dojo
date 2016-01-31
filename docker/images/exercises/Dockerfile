FROM busybox
MAINTAINER Jon Jagger

RUN mkdir -p /var/www/cyber-dojo/exercises
COPY exercises /var/www/cyber-dojo/exercises
WORKDIR /var/www/cyber-dojo/exercises
RUN chown -R www-data:www-data .
RUN chmod -R +r .

VOLUME ["/var/www/cyber-dojo/exercises"]
CMD ["not runnable - a data container"]
