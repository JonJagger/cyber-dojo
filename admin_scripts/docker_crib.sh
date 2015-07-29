#!/bin/bash

echo
echo 'to set shell env variables for boot2docker'
echo '  eval "$(boot2docker shellinit)"'
echo
echo 'to build a container using a dockerfile in the current directory'
echo ' $ docker build -t container .'
echo
echo 'to run a container interactively'
echo ' $ docker run -i -t container /bin/bash'
echo
echo 'to build a data-conly container'
echo ' $ docker run -v /AB/CDE12345 --name="cd_ABCDE12345" git-base true'
echo
echo 'to stop and restart the docker daemon'
echo ' $service docker stop'
echo ' $docker -d --storage-opt dm.basesize=5M'
echo
