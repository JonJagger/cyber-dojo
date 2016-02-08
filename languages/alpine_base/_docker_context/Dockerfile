FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# Need to run old style Ubuntu containers and new style Alpine
# containers (at least while they are upgraded).
# Old style Ubuntu containers ran as user=www-data (33).
# So for compatibility new style Alpine containers have to too.
#
# On the Alpine base image there is already a user with uid=33
# as revealed by [cat /etc/passwd]
#
#   xfs:x:33:33:X Font Server:/etc/X11/fs:/sbin/nologin
#
# So I delete the xfs user to get uid 33 back.
#
# Then I create www-data with uid=33 with these options
#
#     -G group == add user to existing group
#     -D       == don't assign a password
#     -H       == don't create a home directory
#     -u 33    == user-id
#     www-data == name

RUN deluser xfs && adduser -G www-data -D -H -u 33 www-data

# TODO: DROP

RUN apk --update add bash

