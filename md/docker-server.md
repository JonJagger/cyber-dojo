
Docker Server
=============
cyber-dojo probes the host server to see if [docker](https://www.docker.io/)
is installed. If it is then...

When you press the `[create]` button cyber-dojo will only offer
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

cyber-dojo will re-use the docker `image_name` container to execute an animals
`cyber-dojo.sh` file *each* time the animal presses the `[test]` button.

<hr/>
however, if docker is not installed, or if it is but the environment variable
`CYBERDOJO_USE_HOST` is set (to anything) then cyber-dojo will use the
[raw server](md/raw-server.md).


running your own docker'd cyber-dojo server
-------------------------------------------
  * Use the [TurnKey Linux Rails image](http://www.turnkeylinux.org/rails)
  * Install cyber-dojo and docker into it using
    [setup_docker_server.sh](https://raw.githubusercontent.com/JonJagger/cyberdojo/master/admin_scripts/setup_docker_server.sh)


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
$ ruby docker_pull_all.rb
```


adding a new language
---------------------

### build the docker image

  * choose a docker-container to build on top of. For example
    `cyberdojo/build-essential`
    at the [cyberdojo docker index](https://index.docker.io/u/cyberdojo/)
    which was built using this [dockerfile](https://github.com/JonJagger/cyberdojo/blob/master/languages/C-assert/Dockerfile_build_essential)

  * write a dockerfile containing all the
    required commands (eg `apt-get install`)'s.
    <br>For example
    [cyberdojo/languages/C#-NUnit/Dockerfile_csharp_2.10.8.1_nunit](https://github.com/JonJagger/cyberdojo/blob/master/languages/C%23-NUnit/Dockerfile_csharp_2.10.8.1_nunit)

  * use the dockerfile to build your container. For example
    ```bash
    $ docker build -t cyberdojo/my_container .
    ```
    which creates a new container called `cyberdojo/my_container`
    using `Dockerfile` in the current folder `.`
    where `cyberdojo/my_container` is the `image_name` in your
    languages' `manifest.json` file.


### write an output parse function

  * the `unit_test_framework` entry in the languages' `manifest.json`
    file is the name of the function inside `OutputParser.rb`
    used to determine if the output from running `cyber-dojo.sh` in your docker
    container on the animals current files qualifies as a red traffic-light, an amber
    traffic-light, or a green traffic-light.
    There are lots of examples in
    [OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)

  * There are lots of example tests in
    [cyberdojo/test/app_lib](https://github.com/JonJagger/cyberdojo/tree/master/test/app_lib)
    eg
    [output_python_pytest_tests.rb](https://github.com/JonJagger/cyberdojo/blob/master/test/app_lib/output_python_pytest_tests.rb)

### write the languages' manifest.json file

Create a new sub-directory under `cyberdojo/languages/`
<br>By convention name it $languageName-$testFrameworkName
<br>For example:
  ```
  cyberdojo/languages/Lisp-5.6
  ```
Create a `manifest.json` file in this directory.
See [manifest.json details](misc.md)
<br>For example:
  ```
  cyberdojo/languages/Lisp-5.6/manifest.json
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

### check the languages' manifest.json file
There is a ruby script to do this
```bash
$ cd /var/www/cyberdojo/test/installation
$ ruby check_language_manifest.rb ../.. [language-dir]
```
where [language-dir] is the directory of the language you are checking
which contains the `manifest.json` file.
<br>Example
```bash
$ ruby check_language_manifest.rb ../.. Lisp-5.6
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
