
A running cyber-dojo app comprises 6 docker containers, built from 6 images:
(D = data container, R = regular container)

      nginx - (R) cache for web
        web - (R) main rails app
  languages - (D) languages config info, read-only
  exercises - (D) exercises config info, read-only
      katas - (D) practice sessions, read-write
       test - (D) read-write

Each folder contains a build-docker-image.sh script which builds its
image from its Dockerfile.

The katas folder is different since *building* the katas image
(from existing /var/www/cyber-dojo/katas if it exists), rather than
pulling it, is part of installation.
