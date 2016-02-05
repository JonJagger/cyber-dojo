
A running cyber-dojo app comprises 3 docker containers, built from 3 images:
(D = data container, R = regular container)

      nginx - (R) load balancer for web
        web - (R) main rails app
        tmp - (D) where src files are stored ready for the runner

Each folder contains a Dockerfile and a script to build the image from the Dockerfile.


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Launching a docker app that itself uses docker is different
# on different OS's...
#
# On OSX the Docker Quickstart Terminal uses docker-machine to forward
# docker commands to a boot2docker VM called default. In this VM
# the docker binary lives at /usr/local/bin/ and not /usr/bin/
# (as per Ubuntu/Debian)
#
# On Ubuntu the binary has a dependency to
#    /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0
#
# On Debian the binary has a dependency to
#    /usr/lib/x86_64-linux-gnu/libapparmor.so.1.2.0
#
# I originally used docker-compose extension files specific to each OS.
# I now install the correct docker client inside the cyber-dojo image.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

