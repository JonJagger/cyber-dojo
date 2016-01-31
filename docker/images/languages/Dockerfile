FROM busybox
MAINTAINER Jon Jagger

RUN mkdir -p /var/www/cyber-dojo/languages
COPY languages /var/www/cyber-dojo/languages
WORKDIR /var/www/cyber-dojo/languages
RUN chown -R www-data:www-data .
RUN chmod -R +r .

VOLUME ["/var/www/cyber-dojo/languages"]
CMD ["not runnable - a data container"]
