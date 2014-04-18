
docker on the cyber-dojo server
===============================
cyber-dojo probes the host server to see if [docker](https://www.docker.io/)
is installed. If it is then...
  * it will only offer `cyberdojo/languages/*` whose `manifest.json` file
    has an `image_name` entry that exists. For example, if
    ```
    languages/Java-JUnit/manifest.json
    ```
    contains this...
    ```json
    {

      "image_name": "cyberdojo/java-1.8"
    }
    ```
    then Java-JUnit will only be offered as a language on the
    initial create page if the docker image `cyberdojo/java-1.8` exists
    on the server, as determined by running
    ```bash
    $ docker images
    ```
  * it will use the docker `image_name` container to execute an animals
    `cyber-dojo.sh` file each time the animal presses the `[test]` button.
  * however, if the environment variable `CYBERDOJO_USE_HOST`
    is set (to anything) then cyber-dojo will attempt to use the raw
    host server even if docker is installed.


running your own docker'd cyber-dojo server
-------------------------------------------
  * Use the [TurnKey Linux Rails image](http://www.turnkeylinux.org/rails)
  * Install cyber-dojo and docker into it using
    [setup_docker_server.sh](https://raw.githubusercontent.com/JonJagger/cyberdojo/master/admin_scripts/setup_docker_server.sh)


pulling pre-built docker language containers
--------------------------------------------
```bash
$ docker search cyberdojo
```
will tell you the names of the docker container images held in the
[cyberdojo docker index](https://index.docker.io/u/cyberdojo/)
Now do a
```bash
$ docker pull IMAGE_NAME
```
for each IMAGE_NAME matching the `image_name` entry in
each `cyberdojo/languages/*/manifest.json` file that you wish to use.



adding a new language
---------------------

### write the languages' manifest.json file

Create a new sub-directory under `cyberdojo/languages/`
  For example:
  ```
  cyberdojo/languages/Lisp
  ```
Create a `manifest.json` file in this directory.
  For example:
  ```
  cyberdojo/languages/Lisp/manifest.json
  ```
Each `manifest.json` file contains an ruby object in JSON format
Example: the one for Java-JUnit looks like this:
```json
{
  "visible_filenames": [
    "Untitled.java",
    "UntitledTest.java",
    "cyber-dojo.sh"
  ],
  "support_filenames": [
    "junit-4.7.jar"
  ],
  "display_name": "Java",
  "display_test_name": "JUnit",
  "unit_test_framework": "junit",
  "image_name": "cyberdojo/java-1.8",
  "tab_size": 4
}
```
Make sure all the filenames are in the new folder, including cyber-dojo.sh
```bash
$ chmod +x cyber-dojo.sh
$ chown www-data *
$ chgrp www-data *
```

### build the docker image

  * choose a docker-container to build on top of. For example
    `cyberdojo/build-essential`
    at the [cyberdojo docker index](https://index.docker.io/u/cyberdojo/)
    which was built using this [dockerfile](https://github.com/JonJagger/cyberdojo/blob/master/languages/C-assert/Dockerfile_build_essential)

  * write a dockerfile containing all the
    required commands (eg `apt-get install`).
    For example
    [cyberdojo/languages/C#-NUnit/Dockerfile_csharp_nunit](https://github.com/JonJagger/cyberdojo/blob/master/languages/C%23-NUnit/Dockerfile_csharp_nunit)

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
    file is the name of the function inside `OutputParser.rb` which is
    used to determine if the output from running `cyber-dojo.sh` in your container
    on the current files qualifies as a red traffic-light, an amber traffic-light,
    or a green traffic-light.
    There are lots of examples in
    [cyberdojo/app/lib/OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)

  * There are lots of example tests in
    [cyberdojo/test/app_lib](https://github.com/JonJagger/cyberdojo/tree/master/test/app_lib)
    eg
    [output_python_pytest_tests.rb](https://github.com/JonJagger/cyberdojo/blob/master/test/app_lib/output_python_pytest_tests.rb)


### language manifest.json parameters

`"image_name": string`

  The name of docker image to execute `cyber-dojo.sh`.
  Optional. Not required if you're using a raw-server instead
  of a docker-server.
- - - - - - - - - - - - - - - - - - - -
`"visible_filenames": [ string* ]`

  Filenames that will be visible in the browser's editor at startup.
  Each of these files must exist in the directory.
  The filename `cyber-dojo.sh` must be present as a `"visible_filenames"` entry
  or as a `"support_filenames"` entry. This is because `cyber-dojo.sh` is the name
  of the shell file assumed by the ruby code (on the server) to be the start
  point for running the tests. You can write any actions in the `cyber-dojo.sh`
  file but clearly any programs it tries to run must be installed in this
  languages docker container.
  For example, if `cyber-dojo.sh` runs `gcc` to compile C files then `gcc` has
  to be installed. If `cyber-dojo.sh` runs `javac` to compile java files then
  `javac` has to be installed.
- - - - - - - - - - - - - - - - - - - -
`"support_filenames": [ string* ]`

  The names of necessary supporting files. Each of these files must
  exist in the directory. For example, junit .jar files or nunit .dll assemblies.
  These are symlinked from the `cyberdojo/languages` folder to each animals
  `cyberdojo/katas/...` subfolder.
  Despite the name `"support_filenames"` you can symlink a folder if required.
  Not required if you do not need support files.
- - - - - - - - - - - - - - - - - - - -
`"highlight_filenames": [ string* ]`

  Filenames whose appearance are to be highlighted in the browser.
  This can be useful if you have many `"visible_filenames"` and want to mark which
  files form the focus of the practice. A subset of `"visible_filenames"`, but...
  You can also name `instructions` (from the chosen exercise)
  You can also name `output` (always present)
  For example
```json
  "highlight_filenames": [ "buffer.cpp", "buffer.hpp", "instructions" ]
```
  The apperance of `"highlight_filenames"` is controlled by the CSS
  in `cyberdojo/app/assets/stylesheets/kata.css.scss`
```css
    div[class~='filename'][class~='highlight']
    {
      ...
    }
```
  The highlight_filenames entry also interacts with lowlights_filenames
  (see Language.lowlight_filenames() in cyberdojo/app/models/Language.rb)
  (see cd.notLowlightFilenames() in cyberdojo/app/assets/javascripts/cyber-dojo_file_load.js)
  Again, its appearance in controlled from the same CSS file...
```css
    div[class~='filename'][class~='lowlight']
    {
      ...
    }
```
  If there is a `"highlight_filenames"` entry, then lowlight-filenames
  will be
  ```
  [visible_filenames] - [highlight_filenames]
  ```
  If there is no highlight_filenames entry, then lowlight-filenames
  will default to
  ```
  [ 'cyber-dojo', 'makefile' ]
  ```
  Not required. Defaults to empty.
- - - - - - - - - - - - - - - - - - - -
`"display_name": string`

  The name of the language as it appears in the create page (where you select
  your language and exercis) and also in the info
  displayed at the top-left of the test and dashboard pages.
  Optional. Defaults to the name of the folder holding the `manifest.json` file.
- - - - - - - - - - - - - - - - - - - -
`"display_test_name": string`

  The name of the unit-test-framework as it appears in the create page and also in
  in the info displayed at the top-left of the test and dashboard pages.
  Optional. Defaults to the `"unit_test_framework"` value.
- - - - - - - - - - - - - - - - - - - -
`"unit_test_framework": string`

  The name of the unit test framework which partially determines the
  name of the ruby function (on the cyber-dojo server) used to parse the
  test output (to see if the traffic-light is red/green/amber).
  For example, if the value is `cassert` then
      [cyberdojo/app/lib/OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)
  must contain a method called `parse_cassert()` and will be called to parse the
  output of running the tests via the `cyber-dojo.sh` shell file.
  Required. No default.
- - - - - - - - - - - - - - - - - - - -
`"tab_size": int`

  The number of spaces a tab character expands to in the editor
  textarea. Not required. Defaults to 4 spaces.


adding a new exercise
---------------------
  * Create a new sub-directory under `cyberdojo/exercises/`
    Example:
    ```
    cyberdojo/exercises/FizzBuzz
    ```
  * Create a text file called `instructions` in this directory.
    Example:
    ```
    cyberdojo/exercises/FizzBuzz/instructions
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
