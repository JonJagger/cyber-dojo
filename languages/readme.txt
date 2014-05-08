
I structure the docker-containers so that each language
has its own folder with its own base container, and each
language-testFramework has its own folder and its own derived
container. Often a language-testFramework's Dockerfile will
contain nothing except a FROM command. Viz, I could use the
language's base docker-container. But I do it anyway for
regularity.

The base language folders are not seen as languages
when you create a dojo since app/lib/LinuxPaas.rb has an
all_languages() method that returns only languages whose
language/ folder contains a manifest.json file.

Language-testFramework folders contain their supporting files
directly rather than the supporting files (eg .jar files) being
embedded inside the docker container. This is partly
historical since that was the way I did it pre-docker.

