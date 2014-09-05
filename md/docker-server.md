
Docker Server
=============

running your own docker'd cyber-dojo server
-------------------------------------------
* Use the [TurnKey Linux Rails image](http://www.turnkeylinux.org/rails)
* As root...
* Install cyber-dojo
```bash
$ cd /var/www
$ git clone https://JonJagger@github.com/JonJagger/cyberdojo
```
* Install cyberdojo as the default rails server, all the necessary gems and [docker](https://www.docker.io/)
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ./setup_docker_server.sh
```
* Install all the language's docker containers (this will take a while)
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ./docker_pull_all.rb
```


overview of how docker language containers work
-----------------------------------------------

cyber-dojo probes the host server to see if [docker](https://www.docker.io/)
is installed. If it is then
when you press the home page `[create]` button cyber-dojo will only offer
languages whose `manifest.json` file
has an `image_name` entry that exists. For example, if
```bash
cyberdojo/languages/Java-1.8_JUnit/manifest.json
```
contains this...
```json
{
  ...
  "display_name": "Java, JUnit",
  "image_name": "cyberdojo/java-1.8_junit"
}
```
then `Java, JUnit` will only be offered as a (language,test framework)
combination if the docker image `cyberdojo/java-1.8_junit` exists
on the host server, as determined by running
```bash
$ docker images
```

cyber-dojo will re-start the [docker](https://www.docker.io/) `image_name` container to execute an animals
`cyber-dojo.sh` file *each* time the animal presses the `[test]` button.
See [lib/DockerTestRunner.rb](https://github.com/JonJagger/cyberdojo/blob/master/lib/DockerTestRunner.rb)

If [docker](https://www.docker.io/) is *not* installed,
and the environment variable
`CYBERDOJO_USE_HOST` is set then cyber-dojo will use the
[host server](md/host-server.md).




pulling pre-built docker language containers
--------------------------------------------
From the docker'd cyber-dojo server
```bash
$ docker search cyberdojo | sort
```
will tell you the names of the docker container images held in the
[cyberdojo docker index](https://index.docker.io/u/cyberdojo/)
<br>Now do a
```bash
$ docker pull [IMAGE_NAME]
```
for each IMAGE_NAME matching the `image_name` entry in
each `cyberdojo/languages/*/manifest.json` file that you wish to use.

Alternatively, you can pull them all (this will take a while)
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ./docker_pull_all.rb
```



pulling from the cyberdojo github repo
--------------------------------------
```bash
  $ cd /var/www/cyberdojo/admin_scripts
  $ ./pull.sh
```
If pull.sh asks for a password just hit return.
pull.sh performs the following tasks...
  * pulls the latest source from the cyberdojo github repo
  * ensures any new files and folders have the correct group and owner
  * checks for any gemfile changes
  * restarts apache
