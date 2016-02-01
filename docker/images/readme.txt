
A running cyber-dojo app comprises 6 docker containers, built from 6 images:
(D = data container, R = regular container)

  exercises - (D) instructions for every exercise
  languages - (D) manifests for every language+test
      katas - (D) where practice sessions are stored
        tmp - (D) where src files are stored ready for the runner
        web - (R) main rails app
      nginx - (R) load balancer for web

Each folder contains a Dockerfile and a script to build the image from the Dockerfile.
To build them all run ./app_build.sh

There is also a rails folder to build a rails image which is the base image FROM
which the web image is built. The split is so a new web image can be built without
having to do a bundle-install (which takes time).

There is also a test folder to build a data-container holding all the tests.
This allows you to run tests *inside* the container.