# From busybox so we can chown which scratch cant.
FROM busybox
MAINTAINER Jan Sørensen

# docker build -t cyberdojofoundation/katas-data .
# docker create --name cyber-dojo-katas-data-container cyberdojofoundation/katas-data

RUN mkdir -p /var/www/cyber-dojo/katas
# 33 == www-data (apache user)
RUN chown -R 33:33 /var/www/cyber-dojo/katas
VOLUME ["/var/www/cyber-dojo/katas"]

CMD ["not runnable - a data container"]
