
# run as sudo (not tinycorelinux)

addgroup -gid 33 www-data
adduser \
  --home /var/www \
  --gid 33 \
  --shell /bin/sh \
  --uid 33 \
  --disabled-password \
  www-data


