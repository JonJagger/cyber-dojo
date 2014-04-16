
creating your programming dojo
==============================
  * from the home page...
  * click the [create] button
  * click your chosen language|unit-test-framework (eg C++|assert)
  * click your chosen exercise (eg Prime Factors)
  * click the [ok] button
  * you'll get a case-insensitive 6-character hex-id. The full id is ten
    characters long (in the URL) but 6 is enough for uniqueness.


entering your programming dojo
==============================
  * on *each* participating computer...
  * enter the 6-character id into the green input box
  * click the [enter] button
  * the server will tell you which animal you are (eg Panda).
  * click [ok]
  * a new [test] page/tab will open in your browser
  * edit the test files and the code files...
  * press the [test] button to see if the tests pass or not...
  * every time the [test] button is pressed a new traffic-light appears
  * traffic-lights progress along the top, left-to-right, oldest-to-newest.
  * clicking on any traffic-light opens a dialog showing the diffs for
   that traffic-light plus << < > >> buttons to navigate forwards and backwards.


## traffic lights

The result of pressing the [test] button is displayed in the 'output' file
and also as a new traffic-light (at the top). Clicking on a traffic-light
opens a diff-view of the files associated with that traffic-light.
Each traffic-light is coloured as follows:
  * red   - tests ran but at least one failed
  * amber - syntax error somewhere, tests not run
  * green - tests ran and all passed

The colours on the traffic-light are positional, red at the top,
amber in the middle, green at the bottom. This means you can still read the
display if you are colour blind.
You will also get an amber traffic-light if the tests do not complete within
15 seconds (eg you've accidentally coded an infinite loop or the server is
overloaded with too many concurrent practice sessions)
Clicking on any traffic-light opens a dialog showing the diffs for
that traffic-light for that animal together with << < > >> buttons to
navigate forwards and backwards.


reviewing your programming dojo
===============================
You can get to the dashboard page in two ways.
  * from the home page, enter the practice id and click the [review] button.
  * from the test page, click the animal image at the top right

Each horizontal row corresponds to one animal and displays, from left to right,
  * its oldest-to-newest traffic lights
  * its total number of red,amber,green traffic-lights so far (in red,amber,green).
  * its total number of traffic-lights (in the current colour).
  * its animal
  * as always clicking on any traffic-light opens a dialog showing the diffs for
    that traffic-light for that animal together with << < > >> buttons to
    navigate forwards and backwards.


auto refresh?
-------------
The dashboard page auto-refreshes every 10 seconds. As more and more tests
are run, more and more traffic-lights appear taking up more and more
horizontal space. These traffic-lights auto scroll:
  * old ones are scrolled out of view to the left
  * the animal image is always visible to the right.

The idea is to turn off auto-refresh before starting a dashboard review.


|60s| columns?
---------------
When this is checked each vertical column corresponds to 60 seconds.
Every 6 auto-refreshes a new rightmost column will appear
containing all the traffic-lights created by all the animals in those 60
seconds. If no animals press the [test] button during those 60 seconds the
column will contain no traffic-lights at all (instead it will contain
a single dot and be very thin).
When not checked the traffic-lights of different animals are not
vertically time-aligned.


reviewing the diffs
===================
Clicking on any traffic-light opens a dialog showing the diffs for that
traffic-light for that animal. As you navigate forwards and backwards using
the << < > >> buttons the server will stay on the same file if it continues to
have a diff. If it cannot do this (because the file has been renamed or
deleted or has not changed) the server will open the file with the most changes.
When a file is initially opened it autoscrolls to that file's first diff-chunk.
Reclicking on the filename auto-scrolls to the next diff-chunk in the file.
Clicking the red number-of-lines-deleted button (to the right of the filename)
will toggle the deleted lines on/off for that file's diff.
Clicking the green number-of-lines-added button (to the right of the filename)
will toggle the added lines on/off for that file's diff.

The diff is a diff between two traffic-lights. If you click on an animals 13th
traffic-light the diff dialog shows the diff between traffic-lights 12 and 13,
and 12 and 13 appear at the top left next to their respective traffic-lights.
You can show the diff between any two traffic-lights by simply editing these
numbers. For example, if you edit the 13 to a 15 and press return the dialog
will update to display the diff between traffic-lights 12 and 15.
Below the two traffic-lights are  <<  <  >  >>  buttons.
These buttons move forwards and backwards whilst maintaining the traffic-light
gap (eg 12 <-> 15 == 3).

For example, pressing
  * << moves back to the first traffic-light, so if the gap is 3
    it will display the diff of 1 <-> 4
  * <  moves one traffic-light back, so if the gap is 3
    it will display the diff of 11 <-> 14
  * >  moves one traffic-light forward, so if the gap is 3
    it will display the diff of 13 <-> 16
  * >> moves forward to the last traffic-light (eg 65), so if the gap is 3
    it will display the diff of 62 <-> 65

You can also do a "no-diff" by simply entering the same value (eg 23) twice.
23 <-> 23 will display all the files from traffic-light 23 and there will be
no diffs at all. The  << < > >> buttons still work and maintain the "no-diff".
Eg pressing the < button will move back one traffic-light and show the diff
of traffic-lights 22 <-> 22, viz, the files from traffic-light 22.


re-entering your programming dojo
=================================
You can re-enter at any animals' most recent traffic-light by pressing
the re-enter button (from the home page) and then clicking the animal.
This is occasionally useful if one computer has to replace another (eg
if your doing an evening dojo and someone has to leave early).



adding a new exercise
=====================
  * Create a new sub-directory under cyberdojo/exercises/
    Example:
    ```
    cyberdojo/exercises/FizzBuzz
    ```
  * Create a text file called instructions in this directory.
    Example:
    ```
    cyberdojo/exercises/FizzBuzz/instructions
    ```


adding a new language
=====================
Create a new sub-directory under cyberdojo/test/cyberdojo/languages/
  For example:
  ```
  cyberdojo/test/cyberdojo/languages/Lisp
  ```
Create a manifest.json file in this directory.
  For example:
  ```
  cyberdojo/test/cyberdojo/languages/Lisp/manifest.json
  ```
Note the above are
  ```
  cyberdojo/languages
  ```
and not
  ```
  cyberdojo/test/cyberdojo/languages
  ```
Each manifest.json file contains an ruby object in JSON format
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
  "image_name": "cyberdojo/java-1.8"
  "tab_size": 4
}
```
Make sure all the filenames are in the new folder, including cyber-dojo.sh
```bash
$ chmod +x cyber-dojo.sh
$ chown www-data *
$ chgrp www-data *
```


manifest.json parameters
========================
"image_name": string

  The name of docker image to execute cyber-dojo.sh.
  Optional. Not required if you're using a raw-server instead
  of a docker-server.
- - - - - - - - - - - - - - - - - - - -
"visible_filenames": [ string* ]

  Filenames that will be visible in the browser's editor at startup.
  Each of these files must exist in the directory.
  The filename cyber-dojo.sh must be present as a "visible_filenames" entry
  or as a "support_filenames" entry. This is because cyber-dojo.sh is the name
  of the shell file assumed by the ruby code (on the server) to be the start
  point for running the tests. You can write any actions in the cyber-dojo.sh
  file but clearly any programs it tries to run must be installed in the
  environment cyber-dojo.sh is running in.
  For example, if cyber-dojo.sh runs gcc to compile C files then gcc has
  to be installed. If cyber-dojo.sh runs javac to compile java files then
  javac has to be installed.
- - - - - - - - - - - - - - - - - - - -
"support_filenames": [ string* ]

  The names of necessary supporting files. Each of these files must
  exist in the directory. For example, junit .jar files or nunit .dll assemblies.
  These are symlinked from the /languages folder to each animals /katas folder.
  Despite the name "support_filenames" you can symlink a folder if required.
  Not required if you do not need support files.
- - - - - - - - - - - - - - - - - - - -
"highlight_filenames": [ string* ]

  Filenames whose appearance are to be highlighted in the browser.
  This can be useful if you have many "visible_filenames" and want to mark which
  files form the focus of the practice. A subset of visible_filenames, but...
  You can also name "instructions" (from exercises/)
  You can also name "output" (always present)
  For example
```json
  "highlight_filenames": [ "buffer.cpp", "buffer.hpp" ]
```
  Not required. Defaults to empty.
  The apperance of "highlight_filenames" is controlled by the CSS
  in app/assets/stylesheets/kata-dojo.css.scss
```css
    div[class~='filename'][class~='highlight']
    {
      ...
    }
```
  The highlight_filenames entry also interacts with lowlights_filenames
  (see Language.lowlight_filenames() in app/models/Language.rb)
  (see cd.notLowlightFilenames() in app/assets/javascripts/cyber-dojo_file_load.js)
  Again, its appearance in controlled from the same CSS file...
```css
    div[class~='filename'][class~='lowlight']
    {
      ...
    }
```
  If there is a highlight_filenames entry, then lowlight-filenames
  will be [visible_filenames] - [highlight_filenames].
  If there is no highlight_filenames entry, then lowlight-filenames
  will default to ['cyber-dojo','makefile']
- - - - - - - - - - - - - - - - - - - -
"display_name": string

  The name of the language as it appears in the setup page and also in the info
  displayed at the top-left of the test and dashboard pages.
  Optional. Defaults to the name of the folder holding the manifest.json file.
- - - - - - - - - - - - - - - - - - - -
"display_test_name": string

  The name of the unit-test-framework as it appears in the setup page and also in
  in the info displayed at the top-left of the test and dashboard pages.
  Optional. Defaults to the "unit_test_framework" value.
- - - - - - - - - - - - - - - - - - - -
"unit_test_framework": string

  The name of the unit test framework which partially determines the
  name of the ruby function (in the cyber-dojo server) used to parse the
  test output (to see if the traffic-light is red/green/amber).
  For example, if the value is 'cassert' then
      cyberdojo/app/lib/OutputParser.rb
  must contain a method called parse_cassert() and will be called to parse the
  output of running the tests via the cyber-dojo.sh shell file.
  Required. No default.
- - - - - - - - - - - - - - - - - - - -
"tab_size": int

  The number of spaces a tab character expands to in the editor
  textarea. Not required. Defaults to 4 spaces.



DOCKER'D SERVER
===============
cyber-dojo probes the host server to see if [docker](https://www.docker.io/)
is installed. If it is then...
  * it will only offer languages/ whose manifest.json file
    has an "image_name" entry that exists. For example, if
    languages/Java-JUnit/manifest.json contains this...
```json
{
  ...
  "image_name": "cyberdojo/java-1.8"
}
```
    then Java-JUnit will only be offered as a language on the
    initial setup page if the docker image "cyberdojo/java-1.8" exists
    on the host server (as determined by running `docker images`)
  * it will use the docker "image_name" container to execute an animals
    cyber-dojo.sh file each time the animal presses the [test] button.
  * however, if the environment variable CYBERDOJO_USE_HOST
    is set (to anything) then cyber-dojo will use the raw host server
    even if docker is installed.


running your own docker'd cyber-dojo server
-------------------------------------------
Use the [TurnKey Linux Rails image](http://www.turnkeylinux.org/rails)
Install cyber-dojo and docker into it using
[setup_docker_server.sh](https://raw.githubusercontent.com/JonJagger/cyberdojo/master/admin_scripts/setup_docker_server.sh)


installing languages on a docker'd cyber-dojo server
----------------------------------------------------
```bash
$ docker search cyberdojo
```
will tell you the names of the docker container images held in the
[docker cyberdojo index](https://index.docker.io/u/cyberdojo/)
Now do a
```bash
$ docker pull IMAGE_NAME
```
for each IMAGE_NAME matching the image_name entry in
each languages/LANG/manifest.json file that you wish to use.


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




disk space
----------
The design of cyber-dojo is very heavy on inodes. You will almost certainly
run out of inodes before running out of disk space. The folder that eats
the inodes is katas/


katas directory structure
-------------------------
The rails code does NOT use a database.
Instead each practice session lives in a git-like directory structure based
on its 10 character id. For example the session with id 82B583C347 lives at
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
The starting files (as loaded from the wolf/manifests.rb file) form
tag 0 (zero). Each [test] event causes a new git commit and tag, with a
message and tag which is simply the increment number. For example, the fourth
time the wolf computer presses [test] causes
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
It's much easier and more informative to just click on dashboard traffic light.


misc notes
----------
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







RAW SERVER - DEPRECATED
=======================
This is how cyber-dojo runs if docker is not installed or if
the environment variable CYBERDOJO_USE_HOST is set.
In this mode, there is
   NO PROTECTION, NO ISOLATION, NO SECURITY.
   NO PROTECTION, NO ISOLATION, NO SECURITY.
   NO PROTECTION, NO ISOLATION, NO SECURITY.
In this mode cyber-dojo clients have full rights on the cyber-dojo server.
If you setup your own server you are strongly advised to consider using
  * a dedicated server.
  * a virtual box.
  * a dedicated network segment.



running your own raw cyber-dojo server
--------------------------------------
Install [VirtualBox](http://www.virtualbox.org/)
Download the TurnKey Linux image from
http://dl.dropbox.com/u/11033193/CyberDojo/Turnkey-CyberDojo-20120515.ova
(817MB) This image supports 13 languages (C, C++, C#, Coffeescript, Erlang,
Go, Haskell, Java, Javascript, Perl, PHP, Python, Ruby).
Run the ova file in VirtualBox. Mike Long has written some instructions for
this here
http://www.jaggersoft.com/CyberDojoTurnKeyLinuxVirtualBoxserverimageInstructions.pdf
The Virtual Box screen will tell you its IP address, eg 192.168.2.13
Put the URL into your browser. That's it!
Detailed instructions on building your own Turnkey server from scratch are here
http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html


installing languages on a raw server
------------------------------------
The base rails3 image is available here (417MB)
http://dl.dropbox.com/u/11033193/CyberDojo/Turnkey-CyberDojo-20120515.base.ova
(see http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html
for details on how I built it) and supports C, C++, Python, Perl and Ruby.
I installed the other 8+ languages onto this baseline rails 3 image (some of
which are included in the larger 817MB ova file above) as follows...

$apt-get update
-----
Java (125MB)
```
$ apt-get install default-jdk
```
-------
C# (27MB)
```
$ apt-get install mono-gmcs
$ apt-get install nunit-console
$ cd /var/www/cyberdojo/languages/C#
$ rm *.dll
$ cp /usr/lib/cli/nunit.framework-2.4/nunit.framework.dll .
```
I edited the /var/www/cyberdojo/languages/C#/manifest.rb file thus
```
   :support_filenames => %w( nunit.framework.dll )
```
There was a permission issue. Using strace suggested the following
which fixed the problem
```
$ mkdir /var/www/.mono
$ chgrp www-data .mono
$ chown www-data .mono
```
-------
C# NUnit upgrade
I upgraded mono as follows (the server is Ubuntu 10.04 LTS)
```
$ sudo bash -c "echo deb http://badgerports.org lucid main >> /etc/apt/sources.list"
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E1FAD0C
$ sudo apt-get update
$ sudo apt-get install libmono-corlib2.0-cil libmono-system-runtime2.0-cil libmono-system-web2.0-cil libmono-i18n2.0-cil libgdiplus
```
I tried to get NUnit 2.6 to work but it failed with
```
System.ApplicationException: Exception in TestRunnerThread --->
   System.NotImplementedException: The requested feature is not implemented.
   at NUnit.Core.TestExecutionContext.Save () [0x00000] in <filename unknown>:0
```
Googling seems to show this is a known problem!
So I backed up and backed up... until NUnit 2.5.10 which seems to work ok
and still supports the [TestFixture] attribute.
I installed all the new dlls into the gac
```
$ gacutil -i *.dll
```
nunit-console (the command in cyber-dojo.sh) is simply a  script file
which calls nunit-console.exe which is itself a CLI assembly. Viz
```
  #!/bin/sh
  exec /usr/bin/cli /usr/lib/nunit/nunit-console.exe "$@"
```
strace showed that nunit wanted to create some shadow folders...
```
$ chown -R www-data /tmp/nunit20/ShadowCopyCache
$ chgrp -R www-data /tmp/nunit20/ShadowCopyCache
```

-------
Erlang(26MB)
```
$ apt-get install erlang
```
(thanks to Kalervo Kujala)
------
Haskell (111MB)
```
$ apt-get install libghc6-hunit-dev
```
(thanks to Miika-Petteri Matikainen)
------
Go (44MB)
```
$ cd ~
$ wget http://go.googlecode.com/files/go.go1.linux-386.tar.gz
$ tar -C /usr/local -xzf go.go1.linux-386.tar.gz
$ rm go.go1.linux-386.tar.gz
```
I then added the following line to the end of /etc/apache2/envvars/
```
$ export PATH=$PATH:/usr/local/go/bin
```
-----
Javascript (63MB)
```
$ cd ~
$ git clone git://github.com/joyent/node.git
$ cd node
$ git checkout v0.6.17
$ ./configure
$ make
$ make install
$ cd ~
$ rm -r node
```
(see https://github.com/joyent/node/wiki/Installation)
-----
CoffeeScript (3MB)
```
$ npm install --global jasmine-node
```
(thanks to Johannes Brodwall)
(ensure JavaScript node is installed first as per instructions above)
-----
PHP (3MB)
```
$ apt-get install phpunit
```
-----
C/C++ upgrade (80MB)
```
$ sudo apt-get install python-software-properties
$ sudo add-apt-repository ppa:ubuntu-toolchain-r/test
$ sudo apt-get update
$ sudo apt-get install gcc-4.7 g++-4.7
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.4
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
$ sudo update-alternatives --config gcc
```
and select 2. Finally (39MB)
```
$ sudo apt-get install valgrind
```
------
Groovy-JUnit
```
$ apt-get update
$ apt-get install curl
$ curl -s get.gvmtool.net | bash
$ gvm install groovy
```
I then added the following line to the end of /etc/apache2/envvars/
```
export PATH=$PATH:${location-of-groovy-bin}
```
This also gave me the three jars I needed.
  junit-4.11.jar groovy-all-2.1.5.jar hamcrest-core-1.3.jar
(thanks to Schalk Cronje)
------
Groovy-Spock
```
$ grape -Dgrape.root=$(pwd) install org.spockframework spock-core 0.7-groovy-2.0
```
this gave me the spock jar I needed.
(thanks to Schalk Cronje)



pulling the latest cyberdojo github repo
----------------------------------------
You'll need the username and password. I will happily tell you these if
you email me: jon@jaggersoft.com



turning off spell-checking in your browser
------------------------------------------
and avoid annoying red underlines the code editor...
In Chrome
  1. Right click in the editor
  2. Under Spell-checker Options>
  3. Deselect 'Check Spelling in this Field'
In Opera/Firefox
  1. Right click in the editor
  2. Deselect 'Check spelling'



