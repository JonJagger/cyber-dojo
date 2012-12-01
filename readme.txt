
Setup a coding practice
=======================
o) choose your language (eg C++)
   Each language corresponds to a sub-directory of cyberdojo/languages/
   (see below)
o) choose your exercise (eg Prime Factors)
   Each exercise corresponds to a sub-directory of cyberdojo/exercises/
   (see below)
You will be assigned a 10-character id.


Start coding
============
Enter the 10-character id (case insensitive, 5 chars are usually enough)
on each participating computer and click start coding.
The server will assign each computer an animal 'avatar' (eg Panda).
The animal provides identity for each computer.
You can resume coding (from the home page) at any time by choosing
the animal. This is handy if a participant has to leave and take their
laptop as a new laptop can instantly replace it.


Traffic Lights
==============
The display of each test increment uses a traffic light, with meanings 
for the three colours as follows:
  (o) red   - tests ran but at least one failed
  (o) amber - syntax error somewhere, tests not run
  (o) green - tests ran and all passed
The colours are positional, top red, middle amber, bottom green.
This means you can still read the display if you are colour blind.
Note: you will also get an amber traffic light if the tests do not
complete within 10 seconds.


Review-Dashboard
================
The dashboard shows a periodically updating display of all traffic lights
for all the animals in the dojo. If you want to collapse the horizontal time
gaps simply enter a very large value for the seconds_per_column value.


Review-Diff
===========
Clicking on a traffic light opens a new page showing the diffs for that
increment together with < and > buttons to step backwards and  forwards through
the diffs. The diff page does not work properly in Internet Explorer 8.
A diff will automatically open the file with the most changes.
Reclicking a file will auto-scroll to the next diff-chunk in the file.
Clicking the red no-of-lines-deleted button will toggle the deleted lines on/off.
Clicking the green no-of-lines-added button will toggle the added lines on/off.


===========================================================
   VERY VERY IMPORTANT
   VERY VERY IMPORTANT
===========================================================
Cyber-Dojo clients have full rights on the Cyber-Dojo server. If you 
setup your own server you are strongly advised to consider using
o) a dedicated server.
o) a virtual box.
o) a dedicated network segment.


Running your own VirtualBox TurnKey Linux Cyber-Dojo server
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
Detailed instructions on building your own Turnkey server from scratch are also
here http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html


Pulling the latest github source onto your Turnkey server
=========================================================
Add port 12320 to the URL you put into your browser above, eg
192.168.2.13:12320
Now you need the username and password.
I will happily tell you these if you email me: jon@jaggersoft.com
Pull the latest Cyber-Dojo source code from github onto your TurnKey image
>cd /var/www/cyberdojo 
>git pull origin master
Occasionally this will pull new directories. You must ensure these
have the correct rights
>cd /var/www
>chgrp -R www-data cyberdojo
>chown -R www-data cyberdojo
And don't forget to reboot apache
>service apache2 restart
If the server fails to start try
>rm Gemfile.lock
>bundle install
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
the inodes is katas/ If sandboxes/ is ever changed so it retains its contents
between run-tests (eg to support incremental makes in C/C++) then that too
would be a culprit.


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
  :visible_filenames => %w( Untitled.java UntitledTest.java cyber-dojo.sh ),
  :support_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
  :tab_size => 4
}


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
  
:support_filenames
  The names of necessary supporting non-text files. Each of these files must
  exist in the directory. For example, junit jar files or nunit assemblies.
  Not required if you do not need support files.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the Cyber-Dojo server) used to parse the 
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
Instead each kata lives in a git-like directory structure based
on its 10 character id. For example
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
To look at filename's differences between tag 4 and tag 5
>git diff 4 5 sandbox/filename 
It's much easier and more informative to just click on a traffic light.
  

Sandboxes
=========
It used to be the case that a run-the-tests event would cause all the browser's
visible files to be saved into the avatar's sandbox folder along with the
language's hidden files and then the cyber-dojo.sh file would be run on those
files. This is no longer the case. Now, the browser's visible files and the
language's hidden files are saved to a temporary dir under cyberdojo/sandboxes/
and the cyber-dojo.sh file is run from there. This run generates output which
is captured and parsed to determine the appropriate traffic-light colour (red,
amber, or green). Then, the visible files (with the output added to it) and the
red/amber/green status is saved in the avatar's sandbox folder and git
committed. Running the tests is deliberately separated out to its own folder.
This separation offers an easy future route to running dedicated servers just
to run the tests. The structure of temporary cyberdojo/sandboxes sub-folder
(where the tests are run from) mirrors the cyberdojo/katas sub-folder. Eg
  cyberdojo/katas/45/7ED34A21/lion
  cyberdojo/sandboxes/45/7ED34A21/lion
This allows for a possible future feature where the sandbox is not deleted
after each run test event. This could enable, for example, incremental makes.



Only offering installed languages
=================================
The intention is to use a specific structure for the contents of the
manifests to enable an automated check to see what is correctly installed
and working, and to only offer installed and working languages when you
setup a new coding practice. However at the moment when you setup a
new coding practice all languages/ subfolders are offered.

For each language...
o) Cyber-Dojo searches through its manifests' :visible_filenames,
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
   then the Cyber-Dojo server assumes the language is installed and working
   and it will offer that language when you create a new kata.
o) If the three tests return three amber traffic-lights then
   the Cyber-Dojo server assumes the language is not installed
   and it won't offer that language when you configure a new kata.
o) If the three tests return any other combination of traffic-lights
   the Cyber-Dojo server assumes the language is installed but not working.
   
You can test if a languages' initial fileset is correctly setup as follows
>cd cyberdojo/test/installation
>ruby installation_tests.rb
(NB this is out of date and needs reworking after the rails 3 upgrade.)
Note: this may issue the following error
   sh: Syntax error: Bad fd number
when this happened to me I fixed it as follows
>sudo rm /bin/sh
>sudo ln -s /bin/bash /bin/sh


Getting dojos off the VirtualBox TurnKey Linux server
=====================================================
You will need the username and password info to SSH and SFTP.
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
   exercise in Ruby in a very early version of Cyber-Dojo
o) http://vimeo.com/8630305 has a video of an even earlier version of
   Cyber-Dojo I submitted as a proposal to the Software Craftsmanship
   conference 2010.
o) When I started Cyber-Dojo I didn't know any ruby, any rails, or any
   javascript (and not much css or html either). I'm self employed so
   I've have no-one to pair with (except google) while developing this
   in my limited spare time. Some of what you find is likely to be
   non-idiomatic. Caveat emptor!
o) I have worked hard to <em>remove</em> features from Cyber-Dojo. My idea
   is that the simpler the environment the more players will concentrate on
   the practice and the more they will need to collaborate with each other.
   Remember the aim of a Cyber-Dojo is <em>not</em> to ship something.
   The aim of Cyber-Dojo is to deliberately practice developing software
   collaboratively.
o) Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   Cyber-Dojo and have provided lots of help right from the very early days.
   Olve, Mike and Johannes - I really appreciate all your help and
   encouragement.
