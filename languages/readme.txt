
I structure the docker-containers so that each language
has its own folder with its own base container, and each
language/test sub-folder has its own derived
docker-container. Often a language/test Dockerfile
will contain nothing except a FROM command. Viz, I could use
the language's base docker-container. But I do it anyway for
regularity.

language/test folders sometimes contain their supporting
files directly rather than the supporting files (eg .jar files)
being embedded inside the docker container. This is partly
historical since that was the way I did it pre-docker but
it fits well with the readonly docker volume-mounting feature.
An alternative is to put ADD commands into the relevant Dockerfiles
to add supporting files to the created docker container directly.
This would remove the need for sym-linking
and also the need for the docker run language volume.
The support files would be in the sandbox_volume which is read_write.
They could thus be deleted from cyber-dojo.sh but they would magically
re-appear in the next test run!


Languages that use support_filenames (and hence rely on sym-linking)
are
"Bash, shunit2"
"C#, NUnit"
"C#, SpecFlow"
"Clojure, .test"
"F#, NUnit"
"C++, Catch"
"Groovy, JUnit"
"Groovy, Spock"
"Java, Approval"
"Java, Cucumber"
"Java, JMock"
"Java, JUnit"
"Java, Mockito"
"Java, PowerMockito"
"Scala, scalatest"



New docker images are pushed to the cyberdojo registry
https://registry.hub.docker.com/repos/cyberdojo/
as follows
$ docker push cyberdojo/NAME
username: cyberdojo
password: ....
email: jon@jaggersoft.com

