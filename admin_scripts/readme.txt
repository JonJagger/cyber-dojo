
admin_scripts contains a lot of ruby/shell scripts which do
do not work since the LinuxPaas/Docker refactoring.
The exceptions (which do work) are

  setup_docker_server.sh

which you need to run on the Turnkey Rails image to
install cyberdojo from its git repo and also to
apt-get install docker.
And

  save_refactoring_dojos.rb
  load_refactoring_dojos.rb

