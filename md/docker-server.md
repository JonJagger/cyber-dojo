
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
* Install all the necessary gems and [docker](https://www.docker.io/)
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ruby setup_docker_server.rb ..
```
* Install all the languages' docker containers
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ruby docker_pull_all.rb ..
```


overview of how docker language containers work
-----------------------------------------------

cyber-dojo probes the host server to see if [docker](https://www.docker.io/)
is installed. If it is then
when you press the `[create]` button cyber-dojo will only offer
languages whose `manifest.json` file
has an `image_name` entry that exists. For example, if
```bash
cyberdojo/languages/Java-JUnit/manifest.json
```
contains this...
```json
{

  "image_name": "cyberdojo/java-1.8_junit"
}
```
then `Java-JUnit` will only be offered as a language
if the docker image `cyberdojo/java-1.8_junit` exists
on the server, as determined by running
```bash
$ docker images
```
<hr/>

cyber-dojo will re-use the [docker](https://www.docker.io/) `image_name` container to execute an animals
`cyber-dojo.sh` file *each* time the animal presses the `[test]` button.
See [app/lib/DockerRunner.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/DockerRunner.rb)

<hr/>
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
$ docker pull IMAGE_NAME
```
for each IMAGE_NAME matching the `image_name` entry in
each `cyberdojo/languages/*/manifest.json` file that you wish to use.
Alternatively, you can pull them all (this will take a while)
```bash
$ cd /var/www/cyberdojo/
$ ruby admin_scripts/docker_pull_all.rb .
```


adding a new language
---------------------

### build the docker container

  * choose a docker-container to build on top of. For example
    `cyberdojo/build-essential`
    at the [cyberdojo docker index](https://index.docker.io/u/cyberdojo/)
    which was built using this [Dockerfile](https://github.com/JonJagger/cyberdojo/blob/master/languages/build-essential/Dockerfile)

  * write a Dockerfile containing all the
    required commands (eg `apt-get install`)'s.
    <br>For example
    [cyberdojo/languages/C#-NUnit/Dockerfile](https://github.com/JonJagger/cyberdojo/blob/master/languages/C%23-NUnit/Dockerfile)

  * use the dockerfile to build your container. For example
    ```bash
    $ docker build -t cyberdojo/my_container .
    ```
    which creates a new container called `cyberdojo/my_container`
    using `Dockerfile` in the current folder `.`
    where `cyberdojo/my_container` is the `image_name` in your
    languages' `manifest.json` file.


### write an output parse function

  * <deep-breath>
    the `unit_test_framework` entry in the languages' `manifest.json`
    file is the name of the function inside `app/lib/OutputParser.rb`
    used to determine if the output from running `cyber-dojo.sh` in your docker
    container on the animals current files qualifies as a red traffic-light, an amber
    traffic-light, or a green traffic-light.
    </deep-breath>
    There are lots of examples in
    [app/lib/OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)

  * There are lots of example tests in
    [cyberdojo/test/app_lib](https://github.com/JonJagger/cyberdojo/tree/master/test/app_lib)
    eg
    [output_python_pytest_tests.rb](https://github.com/JonJagger/cyberdojo/blob/master/test/app_lib/output_python_pytest_tests.rb)

  * Of course, if the unit-test framework you're using already exists
    in OutputParser.rb you can simply use it.

### write the language's manifest.json file

Create a new sub-directory under `cyberdojo/languages/`
<br>By convention name it $languageName-$testFrameworkName
<br>For example:
  ```
  cyberdojo/languages/Lisp-lut
  ```
Create a `manifest.json` file in this directory.
See [manifest.json details](misc.md)
<br>For example:
  ```
  cyberdojo/languages/Lisp-lut/manifest.json
  ```
Each `manifest.json` file contains an ruby object in JSON format
<br>Example: the one for Java-JUnit looks like this:
```json
{
  "visible_filenames": [
    "Untitled.java",
    "UntitledTest.java",
    "cyber-dojo.sh"
  ],
  "support_filenames": [
    "junit-4.11.jar"
  ],
  "display_name": "Java",
  "display_test_name": "JUnit",
  "unit_test_framework": "junit",
  "image_name": "cyberdojo/java-1.8_junit",
  "tab_size": 4
}
```

### check the language's manifest.json file
There is a ruby script to do this
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ruby check_language_manifest.rb .. [language-dir]
```
where [language-dir] is the directory of the language you are checking
which contains the `manifest.json` file.
<br>Example
```bash
$ ruby check_language_manifest.rb .. Lisp-lut
```


adding a new exercise
---------------------
  * Create a new sub-directory under `/var/www/cyberdojo/exercises/`
    <br>Example:
    ```
    /var/www/cyberdojo/exercises/FizzBuzz
    ```
  * Create a text file called `instructions` in this directory.
    <br>Example:
    ```
    /var/www/cyberdojo/exercises/FizzBuzz/instructions
    ```


pulling from the cyberdojo github repo
--------------------------------------
```bash
  $ cd /var/www/cyberdojo
  $ ./pull.sh
```
If pull.sh asks for a password just hit return.
pull.sh performs the following tasks...
  * pulls the latest source from the cyberdojo github repo
  * ensures any new files and folders have the correct group and owner
  * checks for any gemfile changes
  * restarts apache
