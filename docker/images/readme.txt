
A running cyber-dojo app comprises 5 docker containers, built from 5 images:
(D = data container, R = regular container)

  exercises - the instructions for every exercise
  languages - the manifest for every language+test
        web - the main rails app
        tmp - a place to store incoming src files for the runner to handle
      nginx - a load balancer for web

Each folder contains a Dockerfile and a script to build the image from the Dockerfile.
To build them all run ./app_build.sh

There is also a rails folder to build a rails image which is the base image FROM
which the web image is built. The split is so a new web image can be built without
having to do a bundle-install (which takes time).

There is also a test folder to build a data-container holding all the tests.
This allows you to run tests *inside* the container.