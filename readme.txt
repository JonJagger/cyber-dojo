
Setup a coding practice
=======================
o) from the home page, click the [setup] button
o) choose your language (eg C++)
   Each language corresponds to a sub-directory of cyberdojo/languages/
   (see below)
o) choose your exercise (eg Prime Factors)
   Each exercise corresponds to a sub-directory of cyberdojo/exercises/
   (see below)
o) click the [ok] button.
o) You will get a 6-character id (the full id is actually 10 characters
   long but statistically 6 chars is enough for uniqueness).


Start coding
============
o) Enter the 6-character id (case insensitive) on <em>each</em> participating
   computer and click the [start] button.
o) The server will assign each computer an animal (eg Panda).
   The animal provides identity for each participating computer.
o) On each computer do the chosen exercise by editing the test files and the
   code files, and pressing the [test] button to see if the tests pass or not.
o) Every time the [test] button is pressed a new traffic-light appears at
   the bottom.
o) Traffic-lights progress left-to-right, oldest-to-newest.


Traffic Lights
==============
The result of each pressing the [test] button is displayed in the 'output' file
and also as a new traffic-light (at the bottom). Clicking on a traffic-light
opens a diff-view of the files associated with that traffic-light.
The meanings for the colours on each traffic-light are:
  (o) red   - tests ran but at least one failed
  (o) amber - syntax error somewhere, tests not run
  (o) green - tests ran and all passed
The colours on the traffic-light are positional, red at the top,
amber in the middle, green at the bottom. This means you can still read the
display if you are colour blind.
You will also get an amber traffic-light if the tests do not complete within
15 seconds (eg you've accidentally coded an infinite loop or the server is
overloaded with too many concurrent practice sessions)


Dashboard-Review
================
You can get to the dashboard page in two ways.
o) from the test page, click the animal image at the bottom right
o) from the home page, enter the practice id and click the [review] button.

Each horizontal row corresponds to one animal and displays, from left to right,
o) its oldest-to-newest traffic lights
o) its total number of red,amber,green traffic-lights so far (in red,amber,green).
o) its total number of traffic-lights (in the current colour).
o) its animal

auto refresh?
-------------
The dashboard page auto-refreshes every 10 seconds. As more and more tests
are run, more and more traffic-lights appear taking up more and more
horizontal space. These traffic-lights auto scroll:
o) old ones are scrolled out of view to the left
o) the animal image is always visible.
The idea is to turn off auto-refresh before starting a dashboard review.

|60s| columns?
---------------
When this is checked, each vertical column corresponds to 60 seconds.
Every 6 auto-refreshes a new rightmost column will appear
containing all the traffic-lights created by all the animals in those 60
seconds. If no animals press the [test] button during those 60 seconds the
column will contain no traffic-lights at all (instead it will contain
a single dot and be very thin).
When not checked the traffic-lights of different animals are not
vertically aligned.


Diff-Review
===========
Clicking on any traffic-light opens a dialog showing the diffs for
that traffic-light for that animal together with << < > >> buttons to step
backwards and forwards. As you move forwards and backwards using the
<< < > >> buttons the server will stay on the same file if it continues to
have a diff. If it cannot do this (because the file has been renamed or
deleted or has not changed) the server will open the file with the most changes.
When a file is initially opened it autoscrolls to that file's first diff-chunk.
Reclicking on the filename auto-scrolls to the next diff-chunk in the file
Clicking the red no-of-lines-deleted button (to the right of the filename)
will toggle the deleted lines on/off for that file's diff.
Clicking the green no-of-lines-added button (to the right of the filename)
will toggle the added lines on/off for that file's diff.

The diff is a diff between two traffic-lights. If you click on an animals 13th
traffic-light (on the dashboard) then the diff page will show the diff between
traffic-lights 12 and 13, and the values 12 and 13 will appear at the top left
next to their respective traffic-lights.
You can show the diff between any two traffic-lights by simply editing these
numbers. For example, if you edit the 13 to a 15 and press return the page will
update to display the diff between traffic-lights 12 and 15.
Below the two traffic-lights are  <<  <  >  >>  buttons.
These buttons move forwards and backwards whilst maintaining the traffic-light
gap (eg 12 <-> 15 == 3).
Pressing
o) << moves back to the first traffic-light, so if the gap is 3
   it will display the diff of 1 <-> 4
o) <  moves one traffic-light back, so if the gap is 3
   it will display the diff of 11 <-> 14
o) >  moves one traffic-light forward, so if the gap is 3
   it will display the diff of 13 <-> 16
o) >> moves forward to the last traffic-light (eg 65), so if the gap is 3
   it will display the diff of 62 <-> 65

You can also do a "no-diff" by simply entering the same value (eg 23) twice.
23 <-> 23 will display all the files from traffic-light 23 and there will be
no diffs at all. The  << < > >> buttons still work and maintain the "no-diff".
Eg pressing the < button will move back one traffic-light and show the diff
of traffic-lights 22 <-> 22, viz, the files from traffic-light 22.


Resuming Coding
===============
You can resume at any animals' most recent traffic-light by pressing
the resume button (from the home page) and then clicking
the animal. This is handy if a participant has to leave and take their
laptop as a new laptop can instantly replace it.



===========================================================
   VERY VERY IMPORTANT
   VERY VERY IMPORTANT
===========================================================
cyber-dojo clients have full rights on the cyber-dojo server. If you
setup your own server you are strongly advised to consider using
o) a dedicated server.
o) a virtual box.
o) a dedicated network segment.
A technology that looks very promising for creating isolated
sandboxes on the server is http://www.docker.io/


Running your own VirtualBox TurnKey Linux cyber-dojo server
==========================================================
Install VirtualBox from http://www.virtualbox.org/
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


Pulling the latest github source onto your own cyber-dojo server
================================================================
Add port 12320 to the URL you put into your browser above, eg
192.168.2.13:12320
Now you need the username and password.
I will happily tell you these if you email me: jon@jaggersoft.com
Then grab the latest cyber-dojo source code from github and install it.
  >cd /var/www/cyberdojo
  >git pull origin master
  >chmod +x ./pull.sh
  >./pull.sh
If pull.sh asks for a password just hit return.
pull.sh performs the following tasks...
  o) pulls the latest source from the cyberdojo github repo
  o) ensures any new files and folders have the correct group and owner
  o) checks for any gemfile changes
  o) restarts apache


Versions
========
After Johannes Brodwall's sterling upgrade work my server reports...
>rake about
Ruby version              1.9.3 (i686-linux)
RubyGems version          1.8.24
Rack version              1.4
Rails version             3.2.3
JavaScript Runtime        therubyracer (V8)


Installing Languages
====================
The base rails3 image is available here (417MB)
http://dl.dropbox.com/u/11033193/CyberDojo/Turnkey-CyberDojo-20120515.base.ova
(see http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html
for details on how I built it) and supports C, C++, Python, Perl and Ruby.
I installed the other 8+ languages onto this baseline rails 3 image (some of
which are included in the larger 817MB ova file above) as follows...

#apt-get update
-----Java (125MB)
#apt-get install default-jdk
-------C# (27MB)
#apt-get install mono-gmcs
#apt-get install nunit-console
#cd /var/www/cyberdojo/languages/C#
#rm *.dll
#cp /usr/lib/cli/nunit.framework-2.4/nunit.framework.dll .
I edited the /var/www/cyberdojo/languages/C#/manifest.rb file this
   :support_filenames => %w( nunit.framework.dll )
There was a permission issue. Using strace suggested the following
which fixed the problem
#mkdir /var/www/.mono
#chgrp www-data .mono
#chown www-data .mono
-------C# NUnit upgrade
I upgraded mono as follows (the server is Ubuntu 10.04 LTS)
#sudo bash -c "echo deb http://badgerports.org lucid main >> /etc/apt/sources.list"
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E1FAD0C
#sudo apt-get update
#sudo apt-get install libmono-corlib2.0-cil libmono-system-runtime2.0-cil libmono-system-web2.0-cil libmono-i18n2.0-cil libgdiplus
I tried to get NUnit 2.6 to work but it failed with
System.ApplicationException: Exception in TestRunnerThread --->
   System.NotImplementedException: The requested feature is not implemented.
   at NUnit.Core.TestExecutionContext.Save () [0x00000] in <filename unknown>:0
Googling seems to show this is a known problem!
So I backed up and backed up... until NUnit 2.5.10 which seems to work ok
and still supports the [TestFixture] attribute.
I installed all the new dlls into the gac
#gacutil -i *.dll
nunit-console (the command in cyber-dojo.sh) is simply a  script file
which calls nunit-console.exe which is itself a CLI assembly. Viz
  #!/bin/sh
  exec /usr/bin/cli /usr/lib/nunit/nunit-console.exe "$@"
strace showed that nunit wanted to create some shadow folders...
#chown -R www-data /tmp/nunit20/ShadowCopyCache
#chgrp -R www-data /tmp/nunit20/ShadowCopyCache

-------Erlang(26MB)
#apt-get install erlang
(thanks to Kalervo Kujala)
------Haskell (111MB)
#apt-get install libghc6-hunit-dev
(thanks to Miika-Petteri Matikainen)
------Go (44MB)
#cd ~
#wget http://go.googlecode.com/files/go.go1.linux-386.tar.gz
#tar -C /usr/local -xzf go.go1.linux-386.tar.gz
#rm go.go1.linux-386.tar.gz
I then added the following line to the end of /etc/apache2/envvars/
#export PATH=$PATH:/usr/local/go/bin
-----Javascript (63MB)
#cd ~
#git clone git://github.com/joyent/node.git
#cd node
#git checkout v0.6.17
#./configure
#make
#make install
#cd ~
#rm -r node
(see https://github.com/joyent/node/wiki/Installation)
-----CoffeeScript (3MB)
#npm install --global jasmine-node
(thanks to Johannes Brodwall)
(ensure JavaScript node is installed first as per instructions above)
-----PHP (3MB)
#apt-get install phpunit
-----C/C++ upgrade (80MB)
#sudo apt-get install python-software-properties
#sudo add-apt-repository ppa:ubuntu-toolchain-r/test
#sudo apt-get update
#sudo apt-get install gcc-4.7 g++-4.7
#sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.4
#sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
#sudo update-alternatives --config gcc
and select 2. Finally (39MB)
#sudo apt-get install valgrind
------Groovy-JUnit
#apt-get update
#apt-get install curl
#curl -s get.gvmtool.net | bash
#gvm install groovy
I then added the following line to the end of /etc/apache2/envvars/
#export PATH=$PATH:${location-of-groovy-bin}
This also gave me the three jars I needed.
  junit-4.11.jar groovy-all-2.1.5.jar hamcrest-core-1.3.jar
(thanks to Schalk Cronje)
------Groovy-Spock
#grape -Dgrape.root=$(pwd) install org.spockframework spock-core 0.7-groovy-2.0
this gave me the spock jar I needed.
(thanks to Schalk Cronje)


Disk space
==========
The design of cyber-dojo is very heavy on inodes. You will almost certainly
run out of inodes before running out of disk space. The folder that eats
the inodes is katas/


Adding a new exercise
=====================
1. Create a new sub-directory under cyberdojo/exercises/
  Example: cyberdojo/exercises/FizzBuzz
2. Create a text file called instructions in this directory.
  Example: cyberdojo/exercises/FizzBuzz/instructions


Adding a new language
=====================
Create a new sub-directory under cyberdojo/test/cyberdojo/languages/
  For example: cyberdojo/test/cyberdojo/languages/Lisp
Create a manifest.json file in this directory.
  For example: cyberdojo/test/cyberdojo/languages/Lisp/manifest.json
Note the above are
  cyberdojo/languages
and not
  cyberdojo/test/cyberdojo/languages
Each manifest.json file contains an ruby object in JSON format
Example: the one for Java+JUnit looks like this:
<quote>
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
  "tab_size": 4
}
</quote>
Make sure all the named files are in the new folder, including cyber-dojo.sh
  #chmod +x cyber-dojo.sh
  #chown www-data *
  #chgrp www-data *
Check that running cyber-dojo.sh behaves as required:
  #sudo -u www-data ./cyber-dojo.sh
or maybe
  #strace sudo -u www-data ./cyber-dojo.sh

You can test the setup of a new language using a ruby script.
For example: if the new language is Lisp installed
at cyberdojo/test/cyberdojo/languages/Lisp then
  #cd test/installation
  #ruby check_language.rb ../cyberdojo Lisp
Once this passes make it live by moving it to the live languages folder:
#mv cyberdojo/test/cyberdojo/languages/Lisp cyberdojo/languages/Lisp


manifest.json Parameters
======================
"visible_filenames": [ ... ]
  The names of the text files that will be visible in the browser's editor
  at startup. Each of these files must exist in the directory.
  The filename cyber-dojo.sh must be present as a "visible_filenames" entry
  or as a "support_filenames" entry. This is because cyber-dojo.sh is the name
  of the shell file assumed by the ruby code (in the server) to be the start
  point for running the tests. You can write any actions in the cyber-dojo.sh
  file but clearly any programs it tries to run must be installed on the server.
  For example, if cyber-dojo.sh runs gcc to compile C files then gcc has
  to be installed. If cyber-dojo.sh runs javac to compile java files then
  javac has to be installed.

"higlight_filenames": [ ... ]
  A subset of "visible_filenames" nameing filenames whose appearance
  are to be highlighted in the browser. This can be useful if you have
  many "visible_filenames" and want to mark which files form the focus
  of the practice. For example
  "highlight_filenames": [ "buffer.cpp", "buffer.hpp" ]
  Not required. Defaults to empty.
  The apperance of "highlight_filenames" is controlled by the CSS
   div[class~='filename']
   {
     &[class~='highlight'] {
       &:before { content: ">"; }
     }
   }
  in the file app/assets/stylesheets/cyber-dojo.css.scss

"support_filenames": [ ... ]
  The names of necessary supporting files. Each of these files must
  exist in the directory. For example, junit jar files or nunit assemblies.
  These are symlinked from the /languages folder to each animals /katas folder.
  Despite the name "support_filenames" you can symlink a folder if required
  which can be very handy.
  Not required if you do not need support files.

"display_name": string
  The name of the language as it appears in the setup page and also in the info
  displayed at the top-left of the test page and the dashboard page.
  Optional. Defaults to the name of the folder holding the manifest.json file.

"display_test_name": string
  The name of the unit-test-framework as it appears in the setup page and also in
  in the info displayed at the top-left of the test page and the dashboard page.
  Optional. Defaults to the same as the unit_test_framework setting (next).

"unit_test_framework": string
  The name of the unit test framework which partially determines the
  name of the ruby function (in the cyber-dojo server) used to parse the
  test output (to see if the traffic-light is red/green/amber).
  For example, if the value is 'cassert' then
      cyberdojo/app/lib/OutputParser.rb
  must contain a method called parse_cassert() and will be called to parse the
  output of running the tests via the cyber-dojo.sh shell file.
  Required. No default.

"tab_size": int
  This is the number of spaces a tab character expands to in the editor
  textarea. Not required. Defaults to 4 spaces.


Katas Directory Structure
=========================
The rails code does NOT use a database.
Instead each practice session lives in a git-like directory structure based
on its 10 character id. For example the session with id 82B583C347 lives at
  cyberdojo/katas/82/B583C347
Each started animal has a sub-directory underneath this, eg
  cyberdojo/katas/82/B583C347/wolf
Each started animal has a sandbox sub-directory where its files are held, eg
  cyberdojo/katas/82/B583C347/wolf/sandbox



Git Repositories
================
Each started animal has its own git respository, eg
  cyberdojo/katas/82/B583C347/wolf/.git
The starting files (as loaded from the wolf/manifests.rb file) form
tag 0 (zero). Each run-the-tests event causes a new git commit and tag, with a
message and tag which is simply the increment number. For example, the fourth
time the wolf computer presses the 'test' button causes
>git commit -a -m '4'
>git tag -m '4' 4 HEAD
From an animal's directory you can issue the following commands:
To look at filename for tag 4
>git show 4:sandbox/filename
To look at filename's differences between tag 4 and tag 5
>git diff 4 5 sandbox/filename
It's much easier and more informative to just click on dashboard traffic light.




Only offering installed languages
=================================
The intention is (maybe) to use a specific structure for the contents of the
languages' manifests to enable an automated check to see what is correctly
installed and working, and to only offer installed and working languages when
you setup a new coding practice. At the moment when you setup a
new coding practice all languages/ subfolders are offered.

You can test if a languages' initial fileset is correctly setup as follows
>cd cyberdojo/test/installation
>ruby installation_tests.rb

For each language...
o) cyber-dojo searches through its manifests' :visible_filenames,
   in sequence, looking for any that contain the string '42'
o) If it doesn't find any it will report than language is not
   configured correcty.
o) If it finds at least one file containing '42' it will pick the
   first one as "the-42-file"
o) It will then use the manifest to [create a kata and run-the-tests]
   three times as follows:
   test-1 - with the files unchanged.
   test-2 - with the 42 in the-42-file replaced by 54
   test-3 - with the 42 replaced by 4typo2
o) If test-1 generates a red traffic-light and
      test-2 generates a green traffic-light and
      test-3 generates an amber traffic-light then
   then it will assume the language is installed and working.
o) If the three tests return three amber traffic-lights then
   it will assume the language is not configured correctly.
o) If the three tests return any other combination of traffic-lights
   it will assume the language is installed but not working.

This approach has a flaw: two or more files can contain '42'...
This tends to happen for BDD style testing.


Getting dojos off the VirtualBox TurnKey Linux server
=====================================================
From the review dashboard page click the [download .zip] button.
Zip button now removed. Wanted to see if anyone missed it.
No one did. As usual, it was a feature too far.

If you want to do it from within the actual server you will need
the username and password info to SSH and SFTP.
I will happily tell you it if you email me: jon@jaggersoft.com
1. SSH onto the server
2. cd /var/www/cyberdojo
3. to create a zip file of all dojos
     #ruby zipup.rb true 0 0
   will create zipped_dojos.zip
4. to create a zip file of just one dojo, eg 2F725592E3
     #zip -r zipped_dojo.zip katas/2F/725592E3
5. SFTP the zip file off the server



How to Turn off Chrome Spell-Checking in Chrome
===============================================
To turn it off (and avoid annoying red underlines the code editor)
1. Right click in the editor
2. Under Spell-checker Options>
3. Deselect 'Check Spelling in this Field'


How to Turn off Spell-checking in Opera/Firefox
===============================================
To turn it off (and avoid annoying red underlines the code editor)
1. Right click in the editor
2. Deselect 'Check spelling'


Misc Notes
==========
o) http://vimeo.com/15104374 has a video of me doing the Roman Numerals
   exercise in Ruby in a very early version of cyber-dojo
o) http://vimeo.com/8630305 has a video of an even earlier version of
   cyber-dojo I submitted as a proposal to the Software Craftsmanship
   conference 2010.
o) When I started cyber-dojo I didn't know any ruby, any rails, or any
   javascript (and not much css or html either). I'm self employed so
   I've have no-one to pair with (except google) while developing this
   in my limited spare time. Some of what you find is likely to be
   non-idiomatic. Caveat emptor!
o) I have worked hard to <em>remove</em> features from cyber-dojo.
   The simpler the environment the more players will concentrate on
   the practice and the more they will need to collaborate with each other.
   Remember the aim of a cyber-dojo is <em>not</em> to ship something!
   The aim of cyber-dojo is to deliberately practice developing software
   collaboratively.
o) Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   cyber-dojo and have provided lots of help right from the very early days.
   Mike Sutton and Michel Grootjans too. Olve, Mike, Johannes, Mike and
   Michel - I really appreciate all your help and encouragement.
o) James Grenning uses cyber-dojo a lot, via his own Turnkey S3 cloud servers,
   and has provided awesome feedback and made several very generous donations.
