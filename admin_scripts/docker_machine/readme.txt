
To run docker-machine you first have to run this
eval "$(docker-machine env ${node_name})"
which sets some environment variables which point to certifcates etc.
Can't see how to do that as www-data as it doesn't have a shell.
So I need a new user. Chose cyber-dojo but note this is different
to the rsync cyber-dojo 'user' which is not a real user.

So on Google Developers Console I created a new server node.
SSH'd into the node.

$ userdel -r cyber-dojo
$ adduser cyber-dojo

Added this line to /etc/sudoers.d/custom (new file) so www-data can sudo as cyber-dojo
www-data ALL=(cyber-dojo:cyber-dojo) NOPASSWD:ALL

o) Create server on GCE using SSD drive.
   Created 2CPU server with 200GB SSD drive (similar to amazon).
   Need big drive to hold katas/ and note cyber-dojo is inode hungry
   Debian 8.1 Jessie

   Install docker
   had to do this first
   $ sudo apt-get install apt-transport-https
   Then I could follow instructions here
   http://docs.docker.com/engine/installation/debian/

   Then install docker-machine
   Had to do this first
   $ sudo apt-get install unzip
   Then I could follow instructions here
   http://docs.docker.com/machine/install-machine/
   $ sudo curl -L https://github.com/docker/machine/releases/download/v0.5.0/docker-machine_linux-amd64.zip >machine.zip && \
sudo unzip machine.zip && \
sudo rm machine.zip && \
sudo mv docker-machine* /usr/local/bin


o) install cyber-dojo

   digital-ocean script is the best match as it assumes docker is
   already installed and installs apache passenger ruby etc.
   $ cd /var/www/cyber-dojo/admin_scripts
   $ sudo su -
   $ ./setup_digital_ocean_server.sh

   Running. Building ruby...   Finished.
   Ran $ sudo pull.sh
   And the server is UP!
   Create page fails. What's in the log?
   Ah I think its the old failure of the cache being empty.
   $ sudo docker pull cyberdojofoundation/python_pytest
   $ sudo ./admin_scripts/refresh_all_caches.sh
   Yup. Now create page is ok.
   [test] red/green/amber  All OK.
   $ docker rmi cyberdojofoundation/python_pytest
   Cos I don't need images on the server


o) follow instructions at
  http://docs.docker.com/engine/installation/google/

  $ sudo su -
  $ sudo -u cyber-dojo /bin/bash
  $ curl -sSL https://sdk.cloud.google.com | bash
  $ gcloud auth login
  This gave me a URL, which in turn gave me a key.
  Warning about doing this using a service account is a better way...
  $ gcloud config set project cyber-dojo

o) open port tcp:873 (rsync) for server's IP on Google Developers Console

o) put rsync files into /home/cyber-dojo
   Put new uuidgen password into (rsyncd.password and rsyncd.secrets)
   Put servers IP address into rsyncd.conf

o) create a new node. Has to be done as cyber-dojo user

  $ sudo su -
  $ sudo -u cyber-dojo /bin/bash

  $ docker-machine create \
    --driver google \
    --google-project cyber-dojo \
    --google-zone europe-west1-b \
    --google-machine-type n1-standard-1 \
    --google-disk-size 50 \
    cdf-gce-01

o) install rsync on the new node. Script auto reruns as cyber-dojo user anyway

  $ cd /var/www/cyber-dojo/admin_scripts/docker_machine
  $ ./setup_rsync.sh cdf-gce-02

o) Pull all container images onto new node.
  Have to be root (user that can sudo -u)
  $ sudo su -
  $ ./pull_all.rb cdf-gce-02

o) Refresh the caches
  As root again
  $ cd /var/www/cyber-dojo/admin_scripts/
  $ ./refresh_all_caches.sh

o) Restart the server
  $ service apache2 restart








