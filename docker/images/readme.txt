
A running cyber-dojo app comprises 3 docker containers, built from 3 images:
(D = data container, R = regular container)

        tmp - (D) where src files are stored ready for the runner
        web - (R) main rails app
      nginx - (R) load balancer for web

Each folder contains a Dockerfile and a script to build the image from the Dockerfile.
