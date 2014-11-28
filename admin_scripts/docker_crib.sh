#!/bin/bash

echo
echo 'to build a container using a dockerfile in the current directory'
echo ' $ docker build -t  container .'
echo
echo 'to run a container interactively'
echo ' $ docker run -i -t container /bin/bash'
echo
echo
echo 'to stop and restart the docker daemon'
echo ' $service docker stop'
echo ' $docker -d --storage-opt dm.basesize=5M'
echo
