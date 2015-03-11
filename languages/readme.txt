
I structure the docker-containers so that each language
has its own folder with its own base container, and each
language/test sub-folder and its own derived
docker-container. Often a language/test Dockerfile
will contain nothing except a FROM command. Viz, I could use
the language's base docker-container. But I do it anyway for
regularity.

language/test folders sometimes contain their supporting
files directly rather than the supporting files (eg .jar files)
being embedded inside the docker container. This is partly
historical since that was the way I did it pre-docker but
it fits well with the readonly docker volume-mounting feature.

