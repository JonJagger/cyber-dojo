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
CyberDojo lives in the folder /var/www/cyberdojo 
Pull the latest CyberDojo source code from github onto your TurnKey image
>git pull origin master


Configuring a CyberDojo
=======================
The CyberDojo server will ask you to choose
o) your language (eg C++)
   Each language corresponds to a subfolder of cyberdojo/filesets/language/
o) your kata (eg Prime Factors)
   Each kata corresponds to a subfolder of cyberdojo/filesets/kata/


Entering a CyberDojo
====================
The CyberDojo server will assign you an animal avatar (eg Panda).
The avatar provides identity for each laptop participating in the kata. 
You can resume coding at any time by choosing the avatar. 
This is handy if a laptop has to retire as a new laptop can easily and 
instantly replace it.


Traffic Lights
==============
The display of each run-tests increment uses a traffic light, with meanings 
for the three colours as follows:
  o) red   - tests ran but at least one failed
  o) amber - syntax error somewhere, tests not run
  o) green - tests ran and all passed
The colours are positional, top red, middle amber, bottom green.
This means you can still read the display if you are colour blind.


Dashboard
=========
Shows a periodically updating display of all traffic lights for 
all the computers in the dojo.
If you want to collapse the horizontal time gaps simply enter
a very large value for the seconds_per_column value.


Diff-view
=========
Clicking on a traffic light opens a new page showing the diffs for that increment
together with < and > buttons to step backwards and  forwards through the diffs.
The diff-view page does not work properly in Internet Explorer 8.


Messages
========
Each computer can post tweet like messages which appear on the lower
left hand side. I encourage players to use this to work together, 
particularly when running a dojo with the aim of getting working solutions 
on _all_ laptops (eg in The Average Time To Green Game).


Getting files off the VirtualBox TurnKey Linux server
=====================================================
These were the steps I took...
 0. don't boot the Virtual Box TurnKey Linux server yet
 1. insert a USB stick
 2. in Virtual Box add a filter for the USB stick
 3. remove the USB stick
 4. boot the Virtual Box server and note its IP address (eg 192.168.61.25)
 5. open a browser page to the Virtual Box server (eg 192.168.61.25:12320)
 6. login (you need username and password for this, see above)
 7. insert the USB stick
 8. find the name of the USB device, eg sdb1
 9. >tail /var/log/messages
10. mount the usb device
11. >mkdir /root/usbdrive
12. >mount -t vfat /dev/sdb1 /root/usbdrive
13. >cd /var/www/cyberdojo
14. find the folder you want
15. >ruby names.rb    
16. eg suppose the folder is dojos/82/b583c11…..
17. cd to that folder, then
18. >tar -zcvf name.tar.gz .
19. >mv name.tar.gz /root/usbdrive
20. >umount /dev/sdb1
21. shut down the VBox image

   
Building your own CyberDojo from scratch
========================================
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
>cd cyberdojo directory
>script/server 
Open http://localhost:3000 in your browser and your CyberDojo should be running. 
There are no requirements on the clients (except of course a browser). I also 
install and use apache on my CyberDojo server but that is optional.


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
Initial filesets for twelve languages are provided: C, C++, C#, CoffeeScript,
Erlang, Java, Javascript, Objective C, Python, Perl, PHP, and Ruby. 
Whether you will be able to compile successfully in any of
these languages of course depends on whether these languages are installed on 
your CyberDojo server or not. Ubuntu comes with built-in support for C, C++, 
Python, Perl and you need Ruby for the CyberDojo server itself. 
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
>If you want to run C or C++ directly on a mac and don't want to install Xcode you'll
>need https://github.com/kennethreitz/osx-gcc-installer/downloads
-----Erlang
>Kalervo Kujala added support for Erlang as follows
>sudo apt-get install erlang
>sudo apt-get install erlang-eunit
-----CoffeeScript
>Johannes Brodwall added support for CoffeeScript as follows
> install node as per Javascript support
> sudo npm install --global jasmine-node
If you need to install npm
>curl http://npmjs.org/install.sh | sudo sh
>If you need to install curl
>sudo apt-get install curl


Adding a new language
=====================
Create a new subfolder under cyberdojo/filesets/language/
Create a manifest.rb file in this folder (see manifest.rb below).


Adding a new kata
=================
Create a new subfolder under cyberdojo/filesets/kata/
Create a manifest.rb file in this folder (see manifest.rb below). 


manifest.rb
===========
Each manifest.rb file contains an inspected ruby object. 
Example: cyberdojo/filesets/language/Java/manifest.rb looks like this:
{
  :visible_filenames => %w( Untitled.java UntitledTest.java cyberdojo.sh ),
  :hidden_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
}
Example: cyberdojo/filesets/kata/Prime Factors (*)/manifest.rb looks like this:
{
  :visible_filenames => %w( instructions ),
}


manifest.rb Parameters
======================
:visible_filenames
  The names of files that will be visible in the editor in the browser at 
  startup. Each of these files must exist in the folder.
  The filename cyberdojo.sh should be present (visible or hidden) in one of the 
  manifest.rb files. This is because cyberdojo.sh is the name of the shell file 
  assumed by the ruby code (in the CyberDojo server) to be the start point for  
  running an increment. You can write any actions in the cyberdojo.sh file but 
  clearly any programs it tries to run must be installed on the CyberDojo 
  server. For example, if cyberdojo.sh runs gcc to compile C files then gcc has 
  to be installed. If cyberdojo.sh runs javac to compile java files then javac 
  has to be installed.

:hidden_filenames
  The names of necessary and/or supporting files that are NOT visible in the 
  editor in the browser. Each of these files must exist in the folder. For 
  example, a junit jar file or nunit assemblies. Not needed if you do not need 
  hidden files.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the CyberDojo server) used to parse the 
  run-tests output (to see if the increment passes or fails). For example, if 
  the value is 'cassert' then app/helpers/run_tests_output_parser.rb must 
  contain a method called parse_cassert() and will be called to parse the output 
  of running the tests via the cyberdojo.sh shell file.

There are two more parameters that can be specified in a manifest.rb
file as part of the inspected ruby object:

{
  :max_run_tests_duration => 20,
  :tab_size => 2,
}

:max_run_tests_duration
  This is the maximum number of seconds the CyberDojo server allows an increment 
  to run in (the time starts after all that increments' files have been copied
  to the sandbox folder).  This allows players to continue if they accidentally 
  code an infinite loop for example. Reloaded on each increment so it can be
  modified mid-kata if necessary. Defaults to 10 seconds.

:tab_size
  This is the number of spaces a tab character expands to in the editor textarea.
  Defaults to 4 spaces.


Dojo Folder Structure
=====================
The rails code does NOT use a database.
Instead I use a git-like folder structure based
on the sha1 hexdigest of the dojo's name. For example, a CyberDojo called 
'Jon Jagger' (without the quotes) has a sha1 hexdigest of, wait for it,
  381fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab 
so the root folder for the CyberDojo called 'Jon Jagger' is
  cyberdojo/dojos/38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab
Each started avatar has a subfolder underneath this, for example
  cyberdojo/dojos/38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab/wolf
  

Git Repositories
================
Each started animal avatar has its own git respository, eg
  cyberdojo/dojos/38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab/wolf/.git
The starting files (as loaded via the manifests.rb's :visible_filenames) form
tag 0 (zero). Each run-tests event causes a new git commit and tag, with a 
message and tag which is simply the increment number. For example, the fourth
time the wolf computer presses the run-tests button causes
>git commit -a -m '4'
>git tag -m '4' 4 HEAD
From an avatar's folder you can issue the following commands:
To look at filename for tag 4
>git show 4:sandbox/filename
To look at filename's differences between tag 4 and tag 3
>git diff 4 3 sandbox/filename 
To find the folder from the cyberdojo folder
>ruby names.rb
Which will provide the sha1 based folder name for recent dojos.
It's much easier and more informative to just click on a traffic light.
  

How to Turn off Chrome Spell-Checking in Chrome
===============================================
To turn it off (and avoid annoying red underlines the code editor)
1. Right click in the editor
2. Under Spell-checker Options>
3. Deselect 'Check Spelling in this Field


How to Turn off Spell-checking in Opera/Firefox
===============================================
To turn it off (and avoid annoying red underlines the code editor)
1. Right click in the editor
2. Deselect 'Check spelling'


Misc Notes
==========
o) http://vimeo.com/15104374 has a video of me doing the Roman Numerals kata in 
   Ruby in a very early version of CyberDojo
o) http://vimeo.com/8630305 has a video of an even earlier version of CyberDojo
   I submitted as a proposal to the Software Craftsmanship conference 2010.
o) When I started CyberDojo I didn't know any ruby, any rails, or any javascript
   (and not much css or html either). I'm self employed so I've have no-one to 
   pair with (except google) while developing this in my limited spare time. 
   Some of what you find is likely to be non-idiomatic. Caveat emptor!
o) I have worked hard to <em>remove</em> features from CyberDojo. My idea is that the 
   simpler the environment the more players will concentrate on the practice and
   the more they will need to collaborate with each other. 
   Remember the aim of a CyberDojo is <em>not</em> to ship something, it is to 
   deliberately practice developing software collaboratively.
o) Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   CyberDojo from the very early days.
   Olve, Mike and Johannes - I really appreciate all your help and encouragement.
