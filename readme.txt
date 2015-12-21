
The main setup is to run on a proper server with apache.

There are several runners in lib\

o) DockerMachineRunner
   relies on docker-machine to forward the docker run command
   to slave nodes and relying on docker volume mounts to temporary rsync'd
   locations to give docker containers access to .../katas/...

o) DockerDataContainerRunner
   relies on docker and volume mounts of a docker
   data-container to give the running docker-container
   access to .../katas/...

o) DockerRunner
   relies on docker and direct volume mounts to give the
   running docker-container access to ...katas/...

o) HostRunner
   runs directly on the server with no protection.
   for local testing only.

Set the environment variables CYBER_DOJO_RUNNER_CLASS
to the runner of your choice.

The cyber-dojo github repo assumes it will be cloned into
the /var/www/cyber-dojo folder.

