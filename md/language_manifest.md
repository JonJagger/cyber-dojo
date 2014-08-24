
language manifest.json parameters
=================================

Example: the `manifest.json` file for Java-1.8_JUnit looks like this:
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


"image_name": string
--------------------
The name of the docker image in which `cyber-dojo.sh` is run.
<br>Required.


"visible_filenames": [ string, string, ... ]
--------------------------------------------
Filenames that will be visible in the browser's editor at startup.
Each of these files must exist in the languages' directory.
The filename `cyber-dojo.sh` must be present as a `"visible_filenames"` entry
or as a `"support_filenames"` entry. This is because `cyber-dojo.sh` is the name
of the shell file assumed by the ruby code (in the Rails server) to be the start
point for running the tests. You can write any actions in the `cyber-dojo.sh`
file but clearly any programs it tries to run must be installed in its
language's docker container.
For example, if `cyber-dojo.sh` runs `gcc` to compile C files then `gcc` has
to be installed. If `cyber-dojo.sh` runs `javac` to compile java files then
`javac` has to be installed.
<br>Required.


"support_filenames": [ string, string, ... ]
--------------------------------------------
The names of necessary supporting files which are *not* visible
in browser's editor at startup. Each of these files must
exist in the languages' directory. For example, junit .jar files or
nunit .dll assemblies.
These are sym-linked from the `/var/www/cyberdojo/languages` folder to
each animals
`/var/www/cyberdojo/katas/...` subfolder.
Despite the name `"support_filenames"` you can symlink a folder if required.
<br>Not required if you do not need support files. Defaults to an empty array.


"highlight_filenames": [ string, string, ... ]
----------------------------------------------
Filenames whose appearance are to be highlighted in the browser.
This can be useful if you have many `"visible_filenames"` and want
to mark which files form the focus of the practice.
<br>A subset of `"visible_filenames"`, but...
<br>you can also name `instructions` (from the chosen exercise)
<br>you can also name `output` (always present)
<br>For example
```json
  "highlight_filenames": [ "buffer.cpp", "buffer.hpp", "instructions" ]
```
  The appearance of `"highlight_filenames"` is controlled by the CSS
  in [kata.css.scss](https://github.com/JonJagger/cyberdojo/blob/master/app/assets/stylesheets/kata.css.scss)
```css
    div[class~='filename'][class~='highlight']
    {
      ...
    }
```
The highlight_filenames entry also interacts with lowlights_filenames
<br>see Language.lowlight_filenames() in [Language.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/models/Language.rb)
<br>see cd.notLowlightFilenames() in [cyber-dojo_file_load.js](https://github.com/JonJagger/cyberdojo/blob/master/app/assets/javascripts/cyber-dojo_file_load.js)
<br>Again, its appearance in controlled from the same CSS file...
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
If there is no `"highlight_filenames"` entry, then lowlight-filenames
will default to
```
  [ 'cyber-dojo', 'makefile', 'Makefile' ]
```
<br>Not required. Defaults to an empty array.


"progress_regexs": [ string, string ]
-------------------------------------
Two regexs, the first one to match a red traffic light's
test output, and the second one to match a green traffic light's
test output.
Used on the dashboard to show the test output line (which often
contains the number of passing and failing tests) of each animal's
most recent red/green traffic light. Useful when your practice
session starts from a large number of pre-written tests and
you wish to monitor the progress of each animal.
<br>Not required. Defaults to an empty array.


"filename_extension": string
----------------------------
The filename extension used when creating a new filename.
For example, if set to `".java"` the new filename will be
`filename.java`.
<br>Not required. Defaults to the empty string
(and the new filename will be `filename`).


"display_name": string
----------------------
The name of the (language, test framework) combination as it appears
in the create page (where you select your language and exercise) and
also in the info displayed at the bottom of the test and dashboard pages.
<br>Required.


"unit_test_framework": string
-----------------------------
The name of the unit test framework which partially determines the
name of the ruby function (on the cyber-dojo server) used to parse the
test output (to see if the traffic-light is red/green/amber).
For example, if the value is `cassert` then
    [OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)
must contain a method called `parse_cassert()` and will be called to parse the
output of running the tests via the `cyber-dojo.sh` shell file.
<br>Required.


"tab_size": int
---------------
The number of spaces a tab character expands to in the
browser's textarea editor.
<br>Not required. Defaults to 4 spaces.
