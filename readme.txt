
Setup a coding practice
=======================
o) choose your language (eg C++)
   Each language corresponds to a sub-directory of cyberdojo/languages/
   (see below)
o) choose your exercise (eg Prime Factors)
   Each exercise corresponds to a sub-directory of cyberdojo/exercises/
   (see below)
o) click the [ok] button.
You will get a 6-character id (the full id is actually 10 characters
long but statistically 6 chars is enough for uniqueness).


Start coding
============
Enter the 6-character id (case insensitive) on each participating computer
and click the [start] button.
The server will assign each computer an animal (eg Panda).
The animal provides identity for each participating computer.
Each computer edits the code files and the test files as they work on the
chosen exercise. Each computer presses the [test] button to see if the tests
pass or not. A new traffic-light will appear at the bottom (progressing
left-to-right, oldest-to-newest).


Traffic Lights
==============
The result of each pressing the [test] button is displayed in the 'output' file
and also as a new traffic-light (at the bottom). Clicking on a traffic-light
reverts back to the files for that traffic-light.
The meanings for the three colours on each traffic-light are as follows:
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
o) click the animal image at the top left of the test-coding page, or
   the diff page.
o) from the home page, enter the practice session id and click the [review]
   button.

A new dashboard page will appear displaying all the traffic-lights for all
the animals in the practice session.
The dashboard auto-refreshes every 10 seconds.
The idea is to display the dashboard during the practice session,
then when the practice session ends, you click the [disable] button
(at the top) to stop the auto-refresh.

Each horizontal row corresponds to one animal and displays, from left to right,
o) its oldest-to-newest traffic lights
o) its animal
o) its most recent traffic-light.
o) its total number of red,amber,green traffic-lights so far (in red,amber,green).
o) its total number of traffic-lights (in the current colour).

Each vertical column corresponds to a fixed amount of time
(the [seconds per column] value at the top). If this value is 30 seconds
then every three auto-refreshes a new rightmost column will appear
containing all the traffic-lights created by all the animals in those 30
seconds. If no animals press the [test] button during these 30 seconds the
column will contain no traffic-lights at all (instead it will contain
a single dot and be very thin).
If you want to collapse the horizontal time gaps between traffic-lights
simply enter a very large value for the [seconds per column] value (at the top).

As more and more tests are run, more and more traffic-lights
will be displayed taking up more and more horizontal space.
This can easily cause the column with the animal images and the summary
information to scroll out of sight. If this happens you can simply reduce
the [columns maximum] value at the top of the page. If the [columns maximum]
value is 30 then only the 30 most recent columns will be displayed (older
columns are simply chopped off the left).

If the dashboard display has a horizontal scrollbar you will probably need
to [disable] the auto-refresh before scrolling.


Diff-Review
===========
Clicking on a dashboard traffic-light opens a new page showing the diffs for
that traffic-light for that animal together with << < > >> buttons to step
backwards and forwards. The diff page will automatically
open the file with the most changes and autoscroll to the first diff-chunk.
Clicking on the filename should auto-scroll to the next diff-chunk in the file
(but there is a bug in that somewhere).
Clicking the red no-of-lines-deleted button (to the right of the filename)
will toggle the deleted lines on/off.
Clicking the green no-of-lines-added button (to the right of the filename)
will toggle the added lines on/off.

The diff is a diff between two traffic-lights. If you click on an animals 13th
traffic-light (on the dashboard) then the diff page will show the diff between
traffic-lights 12 and 13, and the values 12 and 13 will appear at the top left
below their respective traffic-lights.
You can show the diff between any two traffic-lights by simply editing these
numbers. For example, if you edit the 13 to a 15 and press return the page will
update to display the diff between traffic-lights 12 and 15.
Below the two traffic-lights are  <<  <  >  >>  buttons.
These buttons move forwards and backwards whilst maintaining the traffic-light
gap (eg 12 -> 15 == 3).
Pressing
o) << moves back to the first traffic-light, so if the gap is 3
   it will display the diff of 1 -> 4
o) <  moves one traffic-light back, so if the gap is 3
   it will display the diff of 11 -> 14
o) >  moves one traffic-light forward, so if the gap is 3
   it will display the diff of 13 -> 16
o) >> moves forward to the last traffic-light (eg 65), so if the gap is 3
   it will display the diff of 62 -> 65

You can also do a "no-diff" by simply entering the same value (eg 23) twice.
23 -> 23 will display all the files from traffic-light 23 and there will be
no diffs at all. The  << < > >> buttons still work and maintain the "no-diff".
Eg pressing the < button will move back one traffic-light and show the diff
of traffic-lights 22 -> 22, viz, the files from traffic-light 22.


Resuming Coding
===============
You can resume at any animals most recent traffic-light by pressing
the resume button (also from the home page) and then clicking
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
Pull the latest cyber-dojo source code from github onto your TurnKey image...
>cd /var/www/cyberdojo 
>git pull origin master
This may pull new files and folders. You must ensure these
have the correct rights...
>cd /var/www/cyberdojo
>chgrp -R www-data app
>chown -R www-data app
Check for any gem changes...
>bundle install
Finally, don't forget to restart apache...
>service apache2 restart

   
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
for details on how I built it) and supports for C, C++,
Python, Perl and Ruby. I installed the other 8 languages onto this baseline
rails 3 image (to create the larger 817MB ova file above) as follows...

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
I then had to add the following line to /etc/apache2/envvars/
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
Create a manifest.rb file in this directory.
  For example: cyberdojo/test/cyberdojo/languages/Lisp/manifest.rb
Each manifest.rb file contains an inspected ruby object. 
Example: the one for Java looks like this:
{
  :visible_filenames => %w( Untitled.java UntitledTest.java cyber-dojo.sh ),
  :support_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
  :tab_size => 4
}
Make sure all the named files are in the new folder, including cyber-dojo.sh
  #chmod +x cyber-dojo.sh
  #chown www-data *
  #chgrp www-data *
Check that running cyber-dojo.sh behaves as required:
  #sudo -u www-data ./cyber-dojo.sh
or maybe
  #strace sudo -u www-data ./cyber-dojo.sh

You can also create a test for your new language in cyberdojo/test/installation
by copying an existing language test rb file. Eg
  #cp clojure_tests.rb lisp_tests.rb
Edit it match the folder name you created
  s/Clojure/Lisp/
Then
  #sudo -u www-data ruby lisp_tests.rb
or
  #strace sudo -u www-data ruby lisp_tests.rb
Once this passes make it live by moving it to the live languages folder:
#mv cyberdojo/test/cyberdojo/languages/Lisp cyberdojo/languages/Lisp


manifest.rb Parameters
======================
:visible_filenames
  The names of the text files that will be visible in the browser's editor
  at startup. Each of these files must exist in the directory.
  The filename cyber-dojo.sh must be present, either as a :visible_filename
  or a :hidden_filename. This is because cyber-dojo.sh is the name of the
  shell file assumed by the ruby code (in the server) to be the start point
  for running the tests. You can write any actions in the cyber-dojo.sh file
  but clearly any programs it tries to run must be installed on the server.
  For example, if cyber-dojo.sh runs gcc to compile C files then gcc has 
  to be installed. If cyber-dojo.sh runs javac to compile java files then
  javac has to be installed.

:hidden_filenames
  The names of text files that are not visible in the browser's editor but
  which will nonetheless be available each time the player runs their tests.
  Each of these files must exist in the directory.
  For example, test framework library code.
  Not required if you do not need hidden files.
  Not currently used anywhere. The plan is that doing a fork will offer a
  page that allows you to control which files are visible and which are not
  (eg to make the test files present but invisible) then this will be needed.
  
:support_filenames
  The names of necessary supporting non-text files. Each of these files must
  exist in the directory. For example, junit jar files or nunit assemblies.
  Not required if you do not need support files.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the cyber-dojo server) used to parse the 
  test output (to see if the increment generates a red/green/amber
  traffic light). For example, if the value is 'cassert' then
      cyberdojo/lib/CodeOutputParser.rb
  must contain a method called parse_cassert() and will be called to parse the
  output of running the tests via the cyber-dojo.sh shell file.
  Required. No default.

:tab_size
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
It's much easier and more informative to just click on a dashboard
traffic light.
  



Only offering installed languages
=================================
The intention is to use a specific structure for the contents of the
languages' manifests to enable an automated check to see what is correctly
installed and working, and to only offer installed and working languages when
you setup a new coding practice. However at the moment when you setup a
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

This approach has a flaw: what if two or more files contain '42'.
This tends to happen for the BDD style testing.


Getting dojos off the VirtualBox TurnKey Linux server
=====================================================
From the review dashboard page click the [download-zip] button.

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
o) I have worked hard to <em>remove</em> features from cyber-dojo. My idea
   is that the simpler the environment the more players will concentrate on
   the practice and the more they will need to collaborate with each other.
   Remember the aim of a cyber-dojo is <em>not</em> to ship something.
   The aim of cyber-dojo is to deliberately practice developing software
   collaboratively.
o) Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   cyber-dojo and have provided lots of help right from the very early days.
   Mike Sutton and Michel Grootjans too. Olve, Mike, Johannes, Mike and
   Michel - I really appreciate all your help and encouragement.
o) James Grenning uses Cyber-Dojo a lot, via his own Turnkey S3 cloud servers.
   James, you've been an awesome "customer". Thanks.