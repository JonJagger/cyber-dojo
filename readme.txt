
The main setup is to run on a proper server with apache.
This currently sets the environment variable CYBER_DOJO_RUNNER_CLASS
to DockerVolumeMountRunner. However, work is underway to migrate away
from volume-mounting to allow scaling using docker-like-swarm. This will
set the environment variable CYBER_DOJO_RUNNER_CLASS to something else.

The cyber-dojo github repo assumes it will be cloned into
the /var/www/cyber-dojo folder.

