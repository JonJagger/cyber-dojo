
I structure the docker-containers so that each language
has its own folder with its own base container, and each
language/test sub-folder has its own derived
docker-container. Sometimes a language/test Dockerfile
will contain nothing except a FROM command. Viz, I could use
the language's base docker-container. But I do it anyway for
regularity.


New docker images are pushed to their cyberdojofoundation hub
https://hub.docker.com/u/cyberdojofoundation/
as follows
$ docker push cyberdojofoundation/NAME
username: jonjagger
password: ....

