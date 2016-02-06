
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
A running cyber-dojo app comprises 6 docker containers, built from 6 images:
(D = data container, R = regular container)

      nginx - (R) load balancer for web
        web - (R) main rails app
  languages - (D) read-only languages config info
  exercises - (D) read-only exercises config info
       test - (D) read-write test
        tmp - (D) where src files are stored ready for the runner

Each folder contains a Dockerfile and a build-docker-image.sh script
to build the image from the Dockerfile.

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Launching a docker app that itself uses docker is different
# on different OS's...
#
# OSX Yosemite
# ------------
# The Docker Quickstart Terminal uses docker-machine to forward
# docker commands to a boot2docker VM called default.
# In this VM the docker binary lives at /usr/local/bin/
#
#    -v /var/run/docker.dock:/var/run/docker.sock
#    -v /usr/local/bin/docker:/usr/local/bin/docker
#
# Ubuntu Trusty
# -------------
# The docker binary lives at /usr/bin and has a dependency on apparmor 1.1
#
#    -v /var/run/docker.dock:/var/run/docker.sock
#    -v /usr/bin/docker:/usr/bin/docker
#    -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0 ...
#
# Debian Jessie
# -------------
# The binary lives at /usr/bin and has a dependency to apparmor 1.2
#
#    -v /var/run/docker.dock:/var/run/docker.sock
#    -v /usr/bin/docker:/usr/bin/docker
#    -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.2.0 ...
#
# I originally used docker-compose extension files specific to each OS.
# I now install a docker client *inside* the cyber-dojo image.
# All that remains is to volume mount the docker socket.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

