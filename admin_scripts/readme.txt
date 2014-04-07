
admin_scripts contains a lot of scripts which do
do not work since the LinuxPaas/Docker refactoring.
The exception is

  setup_docker_server.sh

which you need to run on the Turnkey Rails image to
install cyberdojo from its git repo and also to
apt-get install docker.