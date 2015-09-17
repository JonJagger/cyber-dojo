
I structure the docker-containers so that each language
has its own folder with its own base container, and each
language/test sub-folder has its own derived
docker-container. Sometimes a language/test Dockerfile
will contain nothing except a FROM command. Viz, I could use
the language's base docker-container. But I do it anyway for
regularity.

Every docker container's image needs to be built, either directly,
or indirectly [FROM cyberdojofoundation/build-essential]
This is important for a future git-server + docker-swarm
architecture I am working towards.

New docker images are pushed (by me) to their cyberdojofoundation hub
https://hub.docker.com/u/cyberdojofoundation/
as follows
$ docker login
$ docker push cyberdojofoundation/NAME
username: jonjagger
password: ...
email: ...

