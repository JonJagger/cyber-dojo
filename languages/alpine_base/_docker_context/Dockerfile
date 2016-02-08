FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Alpine upgrade
# --------------
# The new architecture is docker-in-docker (dind). The web server
# now runs in a docker container based on Alpine-linux and the
# large Ubuntu based language images are being refactored to
# smaller Alpine based images.
#
#  1. I don't want to have to upgrade *all* the language
#     containers from Ubuntu to Alpine at the same time.
#  2. I'm supporting running the old Ubuntu language containers
#     from the new dind web server.
#  3. I'm *also* supporting running new Alpine language containers
#     from the old pre-dind web server.
#  4. I don't want two sets of images in the cyberdojofoundation
#     hub so the new language image names are unchanged.
#  5. cyber-dojo.sh files need to work when run in
#     o) bash in Ubuntu based containers
#     o)   sh in Alpine based containers
#     Note that cyber-dojo.sh files don't use a shebang.
#
# So the docker-in-docker web server needs to run new style Alpine language
# containers and, at least until they are upgraded, old style Ubuntu
# language containers too.
#
# Old style Ubuntu containers ran as user=www-data (33).
# So for compatibility new style Alpine containers do too.

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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cyber-dojo.sh needs permission to create files in its /sandbox
# as user=www-data (33). In a docker-in-docker web-container...
#  - the files *exist* in /sandbox but that's really /tmp/... which is on the host.
#    So the hosts view of USER could affect things.
#  - the process that *created* the files is inside the web-container.
#    So the web-container's view of USER could affect things.
#  - the *process* reading the files is inside the language's docker-container.
#    So the language's-container's view of USER could affect things.
# To be sure you need all three to agree on USER {www-data (33)}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN deluser xfs && adduser -G www-data -D -H -u 33 www-data

# See comments in timeout script
COPY ./timeout /usr/local/bin
RUN chmod +x /usr/local/bin/timeout
RUN apk --update add bash
