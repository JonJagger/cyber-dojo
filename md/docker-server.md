
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
$ ./setup_docker_server.rb
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
  "display_name": "Java",
  "display_test_name": "JUnit",
  "image_name": "cyberdojo/java-1.8_junit"
}
```
then `Java-JUnit` will only be offered as a language
if the docker image `cyberdojo/java-1.8_junit` exists
on the server, as determined by running
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
$ docker pull IMAGE_NAME
```
for each IMAGE_NAME matching the `image_name` entry in
each `cyberdojo/languages/*/manifest.json` file that you wish to use.

Alternatively, you can pull them all (this will take a while)
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ./docker_pull_all.rb
```


adding a new language
---------------------

### build a docker container for the language

For example, suppose you were building Lisp-2.3

  * choose a docker-container to build FROM
    <br/>For example
    `cyberdojo/build-essential`
    at the [cyberdojo docker index](https://index.docker.io/u/cyberdojo/)
    which was built using this [Dockerfile](https://github.com/JonJagger/cyberdojo/blob/master/languages/build-essential/Dockerfile)

  * create a folder underneath `cyberdojo/languages/`
    ```bash
    $ md cyberdojo/languages/Lisp-2.3
    ```

  * in your language's folder, create a `Dockerfile`
    ```bash
    $ touch cyberdojo/languages/Lisp-2.3/Dockerfile
    ```
    The first line of this file must name the
    Docker image you chose to build `FROM` in the first step.
    Add commands needed to install your language
    prefixed with `RUN`
    ```
    FROM       cyberdojo/build-essential
    RUN apt-get install -y lispy-2.3
    RUN apt-get install -y ...
    ```
    See for example...
    [cyberdojo/languages/C#/Dockerfile](https://github.com/JonJagger/cyberdojo/blob/master/languages/C%23/Dockerfile)

  * use the `Dockerfile` to try and build your container. For example
    ```bash
    $ docker build -t cyberdojo/Lisp-2.3 .
    ```
    which, if it completes, creates a new docker container
    called `cyberdojo/Lisp-2.3` using `Dockerfile` in
    the current folder `.`

  * write a script called `build-docker-container.sh` to automate
    building your language's docker container
    ```bash
    $ echo cyberdojo/languages/Lisp-2.3/build-docker-container.sh
    #!/bin/bash
    docker build -t cyberdojo/Lisp-2.3 .
    ```

### build a docker container for the (language + unit test)

Repeat the same process, building FROM the docker container
you created in the previous step.<br/>
For example, suppose your Lisp unit-test framework is called LUnit

  * create a folder underneath `cyberdojo/languages/`
    ```bash
    $ md cyberdojo/languages/Lisp-2.3_LUnit
    ```
    Note that this is under `cyberdojo/languages/` and not under
    `cyberdojo/languages/Lisp-2.3/`

  * in your language's folder, create a `Dockerfile`
    ```bash
    $ touch cyberdojo/languages/Lisp-2.3_LUnit/Dockerfile
    ```
    The first line of this file must name the
    docker image you built for your language above.
    Add lines for all the commands needed to install your
    unit-test framework prefixed with `RUN`
    ```
    FROM       cyberdojo/Lisp-2.3
    RUN apt-get install -y lispy-lunit
    RUN apt-get install -y ...
    ```
    If you do not need any commands you should still create
    a `Dockerfile` with the single FROM line.

  * use the `Dockerfile` to try and build your container. For example
    ```bash
    $ docker build -t cyberdojo/Lisp-2.3_LUnit .
    ```
    which, if it completes, creates a new docker container called
    `cyberdojo/Lisp-2.3_LUnit`
    using `Dockerfile`
    in the current folder `.`

  * write a script called `build-docker-container.sh` to automate
    building your (language + unit test) docker container
    ```bash
    $ echo cyberdojo/languages/Lisp-2.3_LUnit/build-docker-container.sh
    #!/bin/bash
    docker build -t cyberdojo/Lisp-2.3_LUnit .
    ```

### write the `manifest.json` file

For example
```bash
$ touch cyberdojo/languages/Lisp-2.3_LUnit/manifest.json
```

Each `manifest.json` file contains an ruby object in JSON format
<br>Example: the one for Java-1.8_JUnit looks like this:
```json
{
  "visible_filenames": [
    "Hiker.java",
    "HikerTest.java",
    "cyber-dojo.sh"
  ],
  "support_filenames": [
    "junit-4.11.jar"
  ],
  "progress_regexs" : [
    "Tests run\\: (\\d)+,(\\s)+Failures\\: (\\d)+",
    "OK \\((\\d)+ test(s)?\\)"
  ],
  "display_name": "Java",
  "display_test_name": "JUnit",
  "unit_test_framework": "junit",
  "image_name": "cyberdojo/java-1.8_junit",
  "tab_size": 4
}
```

Finally you need to create the initial starting files (and
possibly some support files). In honour of Douglas Adams
in  cyber-dojo these always take the form of a function
called answer() which return 6 * 9 and a test for this
function which expects 42. Thus the initial files give
you a red traffic-light.

See [Misc](md/misc.md) for `manifest.json` details.



### write an output parse function

  * Deep-breath...<br/>
    the `unit_test_framework` entry in `manifest.json`
    file names the function inside `app/lib/OutputParser.rb`
    used to determine if the output from running `cyber-dojo.sh` in your Docker
    container on the animals current files qualifies as a
    red traffic-light, an amber traffic-light, or a green traffic-light.<br/>
    And exhale...<br/>
    There are lots of examples in
    [app/lib/OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)

  * There are lots of example tests in
    [cyberdojo/test/app_lib](https://github.com/JonJagger/cyberdojo/tree/master/test/app_lib)
    eg
    [test_output_python_pytest.rb](https://github.com/JonJagger/cyberdojo/blob/master/test/app_lib/test_output_python_pytest.rb)

  * Of course, if the unit-test framework you're using already exists
    in OutputParser.rb you can simply name it and you're done.


### check the language's manifest.json file
There is a ruby script to do this
```bash
$ cd /var/www/cyberdojo/admin_scripts
$ ruby check_language_manifest.rb .. Lisp-2.3_LUnit
```
where the last parameter is the directory of the
language + unit test you are checking (which
contains the `manifest.json` file).


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
