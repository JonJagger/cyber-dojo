
I structure the languages/ folder so that each language
has its own folder with its own _docker_context sub-folder
which contains the Dockerfile (and context) for creating
the language's base docker image. For example:
  languages/Go/_docker_context/Dockerfile
is used to script the creation of the Go docker image.

Each language+test has its own language sub-folder
which in turn has its own _docker_context sub-folder
which contains the Dockerfile (and context) for creating
the language+test's docker image. For example:
  languages/Go/testing/_docker_context/Dockerfile
is used to script the creation of the Go+testing docker image.

Sometimes a language/test's Dockerfile
contains nothing except a FROM command. Viz, I could use
the language's base docker-image. But I do it anyway for
regularity.

New docker images are pushed to their cyberdojofoundation hub
https://hub.docker.com/u/cyberdojofoundation/
as follows

$ docker login
username: jonjagger
password: ...
email: ...

$ docker push cyberdojofoundation/NAME
