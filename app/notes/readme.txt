
The main setup is to run on a proper server with apache.

There are several runners in lib\

o) DockerMachineRunner
   relies on docker-machine to forward the docker run command
   to slave nodes and [docker-machine scp] command to copy
   the katas/... files to the slave node

o) DockerDataContainerRunner
   relies on docker and volume mounts of a docker
   data-container to give the running docker-container
   access to katas/...

o) DockerRunner
   relies on docker and direct volume mounts to give the
   running docker-container access to katas/...


The choice of runner is set in config/cyber-dojo.json

The cyber-dojo github repo assumes it will be cloned into
the /var/www/cyber-dojo folder.

