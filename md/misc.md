
misc
====

language manifest.json parameters
---------------------------------
Example: the `manifest.json` file for Java-JUnit looks like this:
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
- - - - - - - - - - - - - - - - - - - -
`"image_name": string`

  The name of docker image in which `cyber-dojo.sh` is run.
  <br>Optional. Not required if you're using a [raw-server](raw-server.md) instead
  of a docker-server.
- - - - - - - - - - - - - - - - - - - -
`"visible_filenames": [ string* ]`

  Filenames that will be visible in the browser's editor at startup.
  Each of these files must exist in the languages' directory.
  The filename `cyber-dojo.sh` must be present as a `"visible_filenames"` entry
  or as a `"support_filenames"` entry. This is because `cyber-dojo.sh` is the name
  of the shell file assumed by the ruby code (on the server) to be the start
  point for running the tests. You can write any actions in the `cyber-dojo.sh`
  file but clearly any programs it tries to run must be installed in its
  languages docker container (or on the raw server).
  For example, if `cyber-dojo.sh` runs `gcc` to compile C files then `gcc` has
  to be installed. If `cyber-dojo.sh` runs `javac` to compile java files then
  `javac` has to be installed.
- - - - - - - - - - - - - - - - - - - -
`"support_filenames": [ string* ]`

  The names of necessary supporting files. Each of these files must
  exist in the languages' directory. For example, junit .jar files or nunit .dll assemblies.
  These are sym-linked from the `/var/www/cyberdojo/languages` folder to each animals
  `/var/www/cyberdojo/katas/...` subfolder.
  Despite the name `"support_filenames"` you can symlink a folder if required.
  <br>Not required if you do not need support files.
- - - - - - - - - - - - - - - - - - - -
`"highlight_filenames": [ string* ]`

  Filenames whose appearance are to be highlighted in the browser.
  This can be useful if you have many `"visible_filenames"` and want to mark which
  files form the focus of the practice.
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
  Not required. Defaults to empty.
- - - - - - - - - - - - - - - - - - - -
`"display_name": string`

  The name of the language as it appears in the create page (where you select
  your language and exercise) and also in the info
  displayed at the top-left of the test and dashboard pages.
  <br>Optional. Defaults to the name of the language folder holding the
  `manifest.json` file.
- - - - - - - - - - - - - - - - - - - -
`"display_test_name": string`

  The name of the unit-test-framework as it appears in the create page and also in
  in the info displayed at the top-left of the test and dashboard pages.
  <br>Optional. Defaults to the `"unit_test_framework"` value.
- - - - - - - - - - - - - - - - - - - -
`"unit_test_framework": string`

  The name of the unit test framework which partially determines the
  name of the ruby function (on the cyber-dojo server) used to parse the
  test output (to see if the traffic-light is red/green/amber).
  For example, if the value is `cassert` then
      [OutputParser.rb](https://github.com/JonJagger/cyberdojo/blob/master/app/lib/OutputParser.rb)
  must contain a method called `parse_cassert()` and will be called to parse the
  output of running the tests via the `cyber-dojo.sh` shell file.
  <br>Required. No default.
- - - - - - - - - - - - - - - - - - - -
`"tab_size": int`

  The number of spaces a tab character expands to in the editor textarea.
  <br>Not required. Defaults to 4 spaces.



katas directory structure
-------------------------
The rails code does *not* use a database.
Instead each practice session lives in a git-like directory structure based
on its 10 character id. For example the session with id `82B583C347` lives at
```
  cyberdojo/katas/82/B583C347
```
Each started animal has a sub-directory underneath this, eg
```
  cyberdojo/katas/82/B583C347/wolf
```
Each started animal has a sandbox sub-directory where its files are held, eg
```
  cyberdojo/katas/82/B583C347/wolf/sandbox
```


git repositories
----------------
Each started animal has its own git respository, eg
```
  cyberdojo/katas/82/B583C347/wolf/.git
```
The starting files (as loaded from the `cyberdojo/katas/82/B583C347/wolf/manifests.json`
file) form tag 0 (zero). Each `[test]` event causes a new git commit and tag, with a
message and tag which is simply the increment number. For example, the fourth
time the wolf computer presses `[test]` causes
```
$ git commit -a -m '4'
$ git tag -m '4' 4 HEAD
```
From an animal's directory you can issue the following commands:
To look at filename for tag 4
```
$ git show 4:sandbox/filename
```
To look at filename's differences between tag 4 and tag 5
```
$ git diff 4 5 sandbox/filename
```
It's much easier and more informative to just click on a traffic light.


disk space
----------
cyber-dojo is very heavy on inodes. You will probably
run out of inodes before running out of disk space. The folder that eats
the inodes is `cyberdojo/katas/`



turning off spell-checking in your browser
------------------------------------------
and avoid annoying red underlines the code editor...
<br>In Chrome
  * Right click in the editor
  * Under Spell-checker Options>
  * Deselect 'Check Spelling in this Field'
In Opera/Firefox
  * Right click in the editor
  * Deselect 'Check spelling'



notes
-----
  * http://vimeo.com/15104374 has a video of me doing the Roman Numerals
   exercise in Ruby in a very early version of cyber-dojo
  * http://vimeo.com/8630305 has a video of an even earlier version of
   cyber-dojo I submitted as a proposal to the Software Craftsmanship
   conference 2010.
  * When I started cyber-dojo I didn't know any ruby, any rails, or any
   javascript (and not much css or html either). I'm self employed so
   I've have no-one to pair with (except google) while developing this
   in my limited spare time. Some of what you find is likely to be
   non-idiomatic. Caveat emptor!
  * I work hard to *remove* features from cyber-dojo.
   The simpler the environment the more players will concentrate on
   the practice and the more they will need to collaborate with each other.
   Remember the aim of a cyber-dojo is *not* to ship something!
   The aim of cyber-dojo is to deliberately practice developing software
   collaboratively.


thank you
---------
  * Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   cyber-dojo and have provided lots of help right from the very early days.
   Mike Sutton and Michel Grootjans too. Olve, Mike, Johannes, Mike and
   Michel - I really appreciate all your help and encouragement.
  * James Grenning uses cyber-dojo a lot, via his own Turnkey S3 cloud servers,
   and has provided awesome feedback and made several very generous donations.
   Thank you James.
  * Jerry Weinberg showed me the power of experiential learning on all
   of his courses and conferences, notably PSL,
   http://www.estherderby.com/problem-solving-leadership-psl
   which strongly influenced the way I designed cyber-dojo.
   Thank you Jerry.
