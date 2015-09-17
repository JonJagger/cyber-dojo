
The main setup is to run on a proper server with apache.
This currently sets the environment variable CYBER_DOJO_RUNNER_CLASS
to DockerVolumeMountRunner. However, work is underway to migrate away
from volume-mounting to allow scaling using docker-swarm. This will
set the environment variable CYBER_DOJO_RUNNER_CLASS to DockerGitCloneRunner

You can also run your own *local* rails server on your laptop
(assuming you have rails installed) but this is deprecated.
$ /var/www/cyber-dojo/admin_scripts/host_runner_server.sh
Then point your browser at localhost:3000
This sets the environment variable CYBER_DOJO_RUNNER_CLASS to HostRunner
See end of /var/www/cyber-dojo/config/application.rb

The cyber-dojo github repo assumes it will be cloned into 
the /var/www/cyber-dojo folder.

