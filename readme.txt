===========================================================
   VERY VERY IMPORTANT
   VERY VERY IMPORTANT
===========================================================
CyberDojo clients have full rights on the CyberDojo server. If you 
setup your own server you are strongly advised to consider using
o) a dedicated network segment
o) a dedicated server
o) a virtual box.


Running your own VirtualBox TurnKey Linux CyberDojo server
==========================================================
Install VirtualBox from http://www.virtualbox.org/
Download the TurnKey Linux image from
http://dl.dropbox.com/u/22404698/TurnKey-CyberDojo-20110610.ova (478 MB)
Run the ova file in VirtualBox. Mike Long has written some instructions for this here
http://www.jaggersoft.com/CyberDojoTurnKeyLinuxVirtualBoxserverimageInstructions.pdf
The TurnKey image screen will tell you its IP address, eg 192.168.2.13
Put the URL into your browser. That's it!


Pulling the latest github source onto your server
=================================================
Add port 12320 to the URL you put into your browser above, eg
192.168.2.13:12320
Now you need the username and password.
I will happily tell you these if you email me: jon@jaggersoft.com
Pull the latest CyberDojo source code from github onto your TurnKey image
>cd /var/www/cyberdojo 
>git pull origin master
Occasionally this will pull new directories. You must ensure these
have the correct rights
>cd /var/www
>chgrp -R www-data cyberdojo
>chown -R www-data cyberdojo
And don't forget to reboot apache
>apache2ctl restart


Configuring a practice-kata
===========================
The server will ask you to choose
o) a name for your session
o) your language (eg C++)
   Each language corresponds to a sub-directory of cyberdojo/languages/
   (see below)
o) your exercise (eg Prime Factors)
   Each exercise corresponds to a sub-directory of cyberdojo/exercises/
   (see below)


Entering a practice-kata
========================
The server will assign you an animal 'avatar' (eg Panda).
The animal provides identity for each codebase.
You can resume coding at any time by choosing the animal. 
This is handy if a laptop has to retire as a new laptop can easily and 
instantly replace it.


Traffic Lights
==============
The display of each run-tests increment uses a traffic light, with meanings 
for the three colours as follows:
  (o) red   - tests ran but at least one failed
  (o) amber - syntax error somewhere, tests not run
  (o) green - tests ran and all passed
The colours are positional, top red, middle amber, bottom green.
This means you can still read the display if you are colour blind.


Dashboard
=========
Shows a periodically updating display of all traffic lights for 
all the computers in the practice-kata.
If you want to collapse the horizontal time gaps simply enter
a very large value for the seconds_per_column value.


Diff-view
=========
Clicking on a traffic light opens a new page showing the diffs for that increment
together with < and > buttons to step backwards and  forwards through the diffs.
The diff-view page does not work properly in Internet Explorer 8.


Getting files off the VirtualBox TurnKey Linux server
=====================================================
These were the steps I took...
 0. don't boot the VirtualBox TurnKey Linux server yet
 1. insert a USB stick
 2. in VirtualBox add a filter for the USB stick
 3. remove the USB stick
 4. boot the VirtualBox server and note its IP address (eg 192.168.61.25)
 5. open a browser page to the VirtualBox server (eg 192.168.61.25:12320)
 6. login (you need username and password for this, see above)
 7. insert the USB stick
 8. find the name of the USB device, eg sdb1
 9. >tail /var/log/messages
10. mount the usb device
11. >mkdir /root/usbdrive
12. >mount -t vfat /dev/sdb1 /root/usbdrive
13. >cd /var/www/cyberdojo
14. find the directory you want
15. >ruby names.rb    
16. eg suppose the directory is katas/82/B583C115
17. cd to that directory, then
18. >tar -zcvf name.tar.gz .
19. >mv name.tar.gz /root/usbdrive
20. >umount /dev/sdb1
21. shut down the VirtualBox image

   
Building your own CyberDojo Linux server from scratch
=====================================================
Requirements: ruby, rails, git
Here are the commands I used to install ruby, rails, and CyberDojo onto 
my Ubuntu server:
>sudo apt-get install git-core
>git clone http://github.com/JonJagger/cyberdojo.git
>sudo aptitude install ruby build-essential libopenssl-ruby ruby1.8-dev
>sudo apt-get install rubygems
>sudo gem install rails 
>sudo apt-get install libsqlite3-dev
>sudo gem install sqlite3-ruby
>sudo gem update

Then 
>cd cyberdojo
>script/server 
Open http://localhost:3000 in your browser and your CyberDojo should be running. 
There are no requirements on the clients (except of course a browser). I also 
install and use apache on my CyberDojo server but that is optional.


Running a CyberDojo server off a Mac
====================================
This works (but see a caveat below)
Here are the commands Phil Nash used to install CyberDojo on his MacBook
(he already had ruby 1.8.7 and git installed)
>sudo gem update
>sudo gem install rails -v 2.3.8 --include-dependencies
>sudo gem install sqlite3-ruby
 
The MacOs file system can be case insensitive and this could cause git a file
rename problem. If you start a new kata (as Lion say) and do a run-tests and
then change the 'instructions' file to 'Instructions' and make a small change to
its content, and do another run-tests then git diff will not see the difference.
Specifically, from the Lion's directory
>git diff --ignore-space-at-eol --find-copies-harder 2 1 sandbox
will give you an output like this...
     diff --git a/sandbox/instructions b/sandbox/instructions
     index b62fac4..4786df1 100644
     --- a/sandbox/instructions
     +++ b/sandbox/instructions
     @@ -8,7 +8,7 @@ or "frames" for the bowler.
If you look in the Lion's sandbox directory you will see 
a file called Instructions (with a capital I)
If you do this
>irb
>command = `git show 2:manifest.rb`
>manifest = eval command
>manifest.keys
You will see a file called Instructions.
But git diff does not see it... 
Unlikely to be a major problem.


Versions
========
After Mike Long's sterling upgrade work my server reports...
>script/about
Ruby version              1.8.7 (x86_64-linux)
RubyGems version          1.3.7
Rack version              1.1.2
Rails version             2.3.8


Installing Languages
====================
Initial filesets for twelve language+test_framework are provided:
C, C++, C#, CoffeeScript, Erlang, Haskell, Java, Javascript,
Python, Perl, PHP, and Ruby. 
Whether you will be able to compile successfully in any of
these languages of course depends on whether these languages are installed
and working on your server or not. Ubuntu comes with built-in support for C, C++, 
Python, Perl and you need Ruby for the CyberDojo server itself.
Running
>cd cyberdojo/test/unit
>ruby installation_test.rb
Will provide information on what is and isn't installed and working.

-----Java
I installed support for Java as follows
>sudo apt-get install default-jdk
(if asked, press tab to select ok, and hit enter to continue)
-----C#
I installed support for C# as follows
>sudo apt-get install mono-gmcs
>sudo apt-get install nunit-console
-----PHP
I installed support for PHP as follows
>sudo apt-get install php-pear
>sudo pear channel-discover pear.phpunit.de
>sudo pear channel-discover components.ez.no
>sudo pear install PEAR
>sudo pear install phpunit/PHPUnit
>sudo pear install phpunit/PHP_CodeCoverage
-----Javascript
I installed support for Javascript using node. I followed the instructions
at https://github.com/joyent/node/wiki/Installation as follows
>git clone git://github.com/joyent/node.git
>cd node
>git checkout v0.4.11
>./configure
>make -j2
>[sudo] make install
-----C/C++
If you want to run C or C++ directly on a mac and don't want to install Xcode you'll
need https://github.com/kennethreitz/osx-gcc-installer/downloads
-----Erlang
Kalervo Kujala added support for Erlang as follows
>sudo apt-get install erlang
>sudo apt-get install erlang-eunit
-----CoffeeScript
Johannes Brodwall added support for CoffeeScript as follows
>...install node as per Javascript support....
>sudo npm install --global jasmine-node
If you need to install npm
>curl http://npmjs.org/install.sh | sudo sh
If you need to install curl
>sudo apt-get install curl
------Haskell
Miika-Petteri Matikainen added support for Haskell as follows
>sudo apt-get install ghc
>sudo apt-get install libghc6-unit-dev


Adding a new exercise
=====================
1. Create a new sub-directory under cyberdojo/exercises/
  Example: cyberdojo/exercises/FizzBuzz
2. Create a text file called instructions in this directory.
  Example: cyberdojo/exercises/FizzBuzz/instructions


Adding a new language
=====================
Create a new sub-directory under cyberdojo/languages/
  For example: cyberdojo/languages/Lisp
Create a manifest.rb file in this directory.
  For example: cyberdojo/languages/Lisp/manifest.rb
Each manifest.rb file contains an inspected ruby object. 
Example: cyberdojo/languages/Java/manifest.rb looks like this:
{
  :visible_filenames => %w( Untitled.java UntitledTest.java cyberdojo.sh ),
  :support_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
  :tab_size => 4
}

You must structure the contents of the manifests in a
specific way to ensure the CyberDojo server sees them as being
correctly installed and working. For each language...
o) CyberDojo searches through its manifests' :visible_filenames,
   in sequence, looking for any that contain the string '42'
o) If it doesn't find any it will not offer that language when
   you configure a new kata.
o) If it finds at least one file containing '42' it will pick the
   first one as "the-42-file"
o) It will then use the manifest to create a kata and run-the-tests
   three times as follows:
   test-1 - with the files unchanged.
   test-2 - with the 42 in the-42-file replaced by 54
   test-3 - with the 42 replaced by 4typo2
o) If test-1 generates a red traffic-light and
      test-2 generates a green traffic-light and
      test-3 generates an amber traffic-light then
   then the CyberDojo server assumes the language is installed and working
   and it will offer that language when you create a new kata.
o) If the three tests return three amber traffic-lights then
   the CyberDojo server assumes the language is not installed
   and it won't offer that language when you configure a new kata.
o) If the three tests return any other combination of traffic-lights
   the CyberDojo server assumes the language is installed but not working
   and it (soon) won't offer that language when you create a new kata.

You can test if a languages' initial fileset is correctly setup as follows
>cd cyberdojo/test/unit
>ruby installation_tests.rb
Note: this may issue the following error
   sh: Syntax error: Bad fd number
when this happened to me I fixed it as follows
>sudo rm /bin/sh
>sudo ln -s /bin/bash /bin/sh


manifest.rb Parameters
======================
:visible_filenames
  The names of the text files that will be visible in the browser's editor
  at startup. Each of these files must exist in the directory.
  The filename cyberdojo.sh must be present, either as a visible filename or a
  hidden filename. This is because cyberdojo.sh is the name of the shell file 
  assumed by the ruby code (in the server) to be the start point for running
  the tests. You can write any actions in the cyberdojo.sh file but clearly
  any programs it tries to run must be installed on the server.
  For example, if cyberdojo.sh runs gcc to compile C files then gcc has 
  to be installed. If cyberdojo.sh runs javac to compile java files then javac 
  has to be installed.

:hidden_filenames
  The names of text files that are not visible in the browser's editor but
  which will nonetheless be available each time the player runs their tests.
  Each of these files must exist in the directory.
  For example, test framework library code.
  Not required if you do not need hidden files.
  
:support_filenames
  The names of necessary supporting non-text files. Each of these files must
  exist in the directory. For example, junit jar files or nunit assemblies.
  Not required if you do not need support files.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the CyberDojo server) used to parse the 
  run-tests output (to see if the increment generates a red/green/amber
  traffic light). For example, if the value is 'cassert' then
      cyberdojo/lib/CodeOutputParser.rb
  must contain a method called parse_cassert() and will be called to parse the
  output of running the tests via the cyberdojo.sh shell file.
  Required. No default.

:tab_size
  This is the number of spaces a tab character expands to in the editor textarea.
  Not required. Defaults to 4 spaces.


Katas Directory Structure
=========================
The rails code does NOT use a database.
Instead each kata lives in a git-like directory structure based
on the first 10 characters of a uuidgen. For example
  cyberdojo/katas/82/B583C347
Each started avatar has a sub-directory underneath this, for example
  cyberdojo/katas/82/B583C347/wolf
  

Git Repositories
================
Each started animal avatar has its own git respository, eg
  cyberdojo/katas/82/B583C347/wolf/.git
The starting files (as loaded from the wolf/manifests.rb file) form
tag 0 (zero). Each run-the-tests event causes a new git commit and tag, with a 
message and tag which is simply the increment number. For example, the fourth
time the wolf computer presses the run-the-tests button causes
>git commit -a -m '4'
>git tag -m '4' 4 HEAD
From an avatar's directory you can issue the following commands:
To look at filename for tag 4
>git show 4:sandbox/filename
To look at filename's differences between tag 4 and tag 3
>git diff 4 3 sandbox/filename 
To find the directory issue the following from the cyberdojo/ directory 
>ruby names.rb
Which will provide the uuidgen based directory names for recent katas.
It's much easier and more informative to just click on a traffic light.
  

Sandboxes
=========
It used to be the case that a run-the-tests event would cause all the browser's
visible files to be saved into the avatar's sandbox folder along with the
language's hidden files and then the cyberdojo.sh file would be run on those
files. This is no longer the case. Now, the browser's visible files and the
language's hidden files are saved to a temporary dir under cyberdojo/sandboxes/
and the cyberdojo.sh file is run from there. This run generates output which is
captured and parsed to determine the appropriate traffic-light colour (red,
amber, or green). Then, the visible files (with the output added to it) and the
red/amber/green status is saved in the avatar's sandbox folder and git
committed. Running the tests is deliberately separated out to its own folder.
This separation offers an easy future route to running dedicated servers just
to run the tests.


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
   exercise in Ruby in a very early version of CyberDojo
o) http://vimeo.com/8630305 has a video of an even earlier version of CyberDojo
   I submitted as a proposal to the Software Craftsmanship conference 2010.
o) When I started CyberDojo I didn't know any ruby, any rails, or any javascript
   (and not much css or html either). I'm self employed so I've have no-one to 
   pair with (except google) while developing this in my limited spare time. 
   Some of what you find is likely to be non-idiomatic. Caveat emptor!
o) I have worked hard to <em>remove</em> features from CyberDojo. My idea is that
   the simpler the environment the more players will concentrate on the practice
   and the more they will need to collaborate with each other. Remember the aim
   of a CyberDojo is <em>not</em> to ship something. The aim of CyberDojo is to
   deliberately practice developing software collaboratively.
o) Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   CyberDojo from the very early days.
   Olve, Mike and Johannes - I really appreciate all your help and encouragement.
