
Launching a docker app that itself uses docker is different on different OS's.
I originally used docker-compose extension files specific to each OS.
See https://docs.docker.com/compose/extends/ and below.
I now install a docker client *inside* the cyber-dojo web image.
See docker/web/Dockerfile

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSX Yosemite
------------
The Docker-Quickstart-Terminal uses docker-machine to forward
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
The docker binary lives at /usr/bin and has a dependency to apparmor 1.2

   -v /var/run/docker.dock:/var/run/docker.sock
   -v /usr/bin/docker:/usr/bin/docker
   -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.2.0 ...

