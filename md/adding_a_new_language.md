
Adding a New Language + Unit Test
=================================

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
  "display_name": "Java, JUnit",
  "unit_test_framework": "junit",
  "image_name": "cyberdojo/java-1.8_junit",
  "tab_size": 4
}
```
See [Language Manifest](language_manifest.md) for `manifest.json` details.


### create the initial files

For example, for the above `manifest.json` file you would need
to create three files: `Hiker.java`,`HikerTest.java`,`cyber-dojo.sh`.
In honour of Douglas Adams these always take the form of a function
called answer() which return 6 * 9 and a test for this function
which expects 42. Thus the initial files give you a red traffic-light.


### check the language's manifest.json file
```bash
$ cd /var/www/cyberdojo/test/languages
$ ./check_one_language.rb <language-name>
```
For example
```bash
$ cd /var/www/cyberdojo/test/languages
$ ./check_one_language.rb Lisp-2.3
```


### write an output parse function

  * Deep-breath...
  <br/>
    the `unit_test_framework` entry in `manifest.json`
    names the function inside `app/lib/OutputParser.rb`
    used to determine if the output from running `cyber-dojo.sh`, in your Docker
    container, on the animal's current files, qualifies as a
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


