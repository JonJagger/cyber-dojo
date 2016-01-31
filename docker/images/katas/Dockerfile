FROM busybox
MAINTAINER Jon Jagger

USER www-data
RUN mkdir -p /var/www/cyber-dojo/katas
COPY katas /var/www/cyber-dojo/katas
WORKDIR /var/www/cyber-dojo/katas
RUN chown -R www-data:www-data .
RUN chmod -R +r .

VOLUME ["/var/www/cyber-dojo/katas"]
CMD ["not runnable - a data container"]
