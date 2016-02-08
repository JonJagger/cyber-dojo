FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# Old style servers run with user=www-data (33) inside apache.
# New Alpine based images are run as www-data (33) so they will
# work on old-style servers.
#
# For maximum compatibility the www-data user needs same uid on
# o) apache server (33)
# o) language images and web image (all based on alpine)
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

# Old style servers called docker run /bin/bash -c ...
# so to maintain compatibility new images need to have bash
# See comments for timeout.

RUN apk --update add bash

