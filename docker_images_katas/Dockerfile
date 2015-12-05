# From busybox so we can chown which scratch cant.
FROM busybox
MAINTAINER Jan Sørensen

# docker build -t cyberdojofoundation/katas-data .
# docker rm cyber-dojo-katas-data-container
# docker create --name cyber-dojo-katas-data-container cyberdojofoundation/katas-data

RUN mkdir -p /var/www/cyber-dojo/katas
# 33 == www-data (apache user)
RUN chown -R 33:33 /var/www/cyber-dojo/katas
VOLUME ["/var/www/cyber-dojo/katas"]

CMD ["can not run - data container"]
