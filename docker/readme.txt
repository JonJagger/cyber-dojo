
A running cyber-dojo app comprises 7 docker containers, built from 7 images:
(D = data container, R = regular container)

      nginx - (R) cache for web
        web - (R) main rails app
  languages - (D) languages config info, read-only
  exercises - (D) exercises config info, read-only
      katas - (D) practice sessions, read-write
       test - (D) read-write
        tmp - (D) stores src files ready for the runner, read-write

Each folder contains a build-docker-image.sh script which builds its
image from its Dockerfile.
The katas folder is different since *building* the katas image
(from existing /var/www/cyber-dojo/katas if it exists), rather than
pulling it, is part of installation.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Launching a docker app that itself uses docker is different on different OS's.
I originally used docker-compose extension files specific to each OS.
See https://docs.docker.com/compose/extends/ and below.
I now install a docker client *inside* the cyber-dojo image.
See docker/web/Dockerfile

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSX Yosemite
------------
The Docker Quickstart Terminal uses docker-machine to forward
docker commands to a boot2docker VM called default.
In this VM the docker binary lives at /usr/local/bin/

   -v /var/run/docker.dock:/var/run/docker.sock
   -v /usr/local/bin/docker:/usr/local/bin/docker

Ubuntu Trusty
-------------
The docker binary lives at /usr/bin and has a dependency on apparmor 1.1

   -v /var/run/docker.dock:/var/run/docker.sock
   -v /usr/bin/docker:/usr/bin/docker
   -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0 ...

Debian Jessie
-------------
The binary lives at /usr/bin and has a dependency to apparmor 1.2

   -v /var/run/docker.dock:/var/run/docker.sock
   -v /usr/bin/docker:/usr/bin/docker
   -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.2.0 ...

