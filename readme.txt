
===========================================================
   VERY VERY IMPORTANT - VERY VERY IMPORTANT
===========================================================
CyberDojo clients have full rights on the CyberDojo server. If you 
setup your own CyberServer you are strongly advised to consider using
o) a dedicated network segment
o) a dedicated server
o) a virtual box.
===========================================================


Requirements
============
Ruby
Rails
git


Installing CyberDojo
====================
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


Installation Update
===================
Emily Bache created a cyberdojo server starting from the aging instructions
above and reported the following issues (many thanks Emily)
>I got an error when installing rails:
>
>Error installing rails:
>    bundler requires RubyGems version >= 1.3.6
>
>I found this helpful blog post which explains what to do about this:
>
>http://blog.eike.se/2010/08/rails-3-on-ubuntu-910.html
>
>Then I when I tried to start rails I got an error with rack:
>
>version error: rack(1.2.1 not ~> 1.0.0) (Gem::LoadError)
>
>I installed the earlier version like this:
>
>sudo gem install rack -v 1.0.0
>
>Then when installing java, the package seems to have changed name:
>
>Couldn't find package oracle-java6-sdk
>
>I instead installed package "default-jdk", which pulled in a lot of stuff.
>
>With C#, I found that in file 
>
>cyberdojo/filesets/language/C#/cyberdojo.sh
>
>was trying to run the program "nunit-console2", whereas the one I had installed was called "nunit-console". So I edited >that file and then I could use C# in the dojo.



Installing Languages
====================
Initial filesets for ten languages are provided: C, C++, C#, Objective C, 
Java, Javascript, Python, Perl, PHP, and Ruby. 
Whether you will be able to compile successfully in any of
these languages of course depends on whether these languages are installed on 
your CyberDojo server or not. Ubuntu comes with built-in support for C, C++, 
Python, Perl and you need Ruby for the CyberDojo server itself. 
I installed support for Java as follows
>sudo apt-get install sun-java6-sdk
(when asked, press tab to select ok, and hit enter to continue)
I installed support for C# as follows
>sudo apt-get install mono-gmcs
>sudo apt-get install nunit-console
I installed support for PHP as follows
>sudo apt-get install php-pear
>sudo pear channel-discover pear.phpunit.de
>sudo pear channel-discover pear.symfony-project.com
>sudo pear install phpunit/PHPUnit
I also had to edit /etc/php5/conf.d/mcrypt.ini
So its first line reads
; configuration for php MCrypt module
instead of
# configuration for php MCrypt module
I installed support for Objective C as follows
>sudo apt-get -y install build-essential
>sudo apt-get install gobjc
>sudo apt-get install libgnustep-base-dev
I installed support for Javascript using Rhino. I downloaded rhino_7R2.zip from 
https://developer.mozilla.org/en/RhinoDownload which contains the necessary
js.jar file. Rhino runs on top of Java.


Starting a Kata
===============
Once you have created and entered your dojo the CyberDojo server will ask you to choose 
o) your animal avatar  (eg Pandas)
   The avatar provides identity for each laptop participating in the kata. 
o) your language (eg C++)
   Each language corresponds to a subfolder of cyberdojo/filesets/language/
o) your kata (eg Prime Factors)
   Each kata corresponds to a subfolder of cyberdojo/filesets/kata/
   
If you have not selected any of these when you press the Start button
the CyberDojo server will make random selections for you.
If you select an avatar that has already started then your language and kata
selections (if any) will be ignored and you will restart where that avatar
left off. This is handy if a laptop has to retire as a new laptop can easily
and instantly replace it.


Dojo Folder Structure
=====================
The rails code does NOT use a database.
Originally the name of each dojo corresponded to a subfolder underneath
cyberdojo/dojos/ however the number of subfolders started to get large
so this has now changed. Instead I use a git-like folder structure based
on the sha1 hexdigest of the dojo's name. For example, a CyberDojo called 
'Jon Jagger' (without the quotes) has a sha1 hexdigest of, wait for it,
  381fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab 
so the root folder for the CyberDojo called 'Jon Jagger' is
  cyberdojo/dojos/38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab
Each started avatar has a subfolder underneath this, for example
  cyberdojo/dojos/38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab/wolves
  

Git Repositories
================
Each started avatar has its own git respository, eg
  cyberdojo/dojos/38/1fa3eaa1a1352eb4bd6b537abbfc4fd57f07ab/wolves/.git
The starting files (as loaded via the manifests.rb's :visible_filenames) form
tag 0 (zero). Each run-tests event causes a new git commit and tag, with a 
message and tag which is simply the increment number. For example, the fourth
time the wolves press the run-tests button causes
>git commit -a -m '4'
>git tag -m '4' 4 HEAD
From an avatar's folder you can issue the following commands:
To look at filename for tag 4
>git show 4:sandbox/filename
To look at filename's differences between tag 4 and tag 3
>git diff 4 3 sandbox/filename 


Traffic Lights
==============
The display of each increment now uses a traffic light making the colours
positional. This means you can still read the display if you are colour blind
(which a surprising number of people are). 
o) Top Red = tests ran but at least one failed
o) Middle Yellow = syntax error somewhere, tests not run
o) Bottom Green = tests ran and all passed


Adding a new language
=====================
Create a new subfolder under cyberdojo/filesets/language/
Create a manifest.rb file in this folder (see below). 
(see Manifests below)


Adding a new kata
=================
Create a new subfolder under cyberdojo/filesets/kata/
Create a manifest.rb file in this folder (see below). 


manifest.rb
===========
Each manifest.rb file contains an inspected ruby object. 
For example: cyberdojo/filesets/language/Java/manifest.rb looks like this:
{
  :visible_filenames => %w( Untitled.java UntitledTest.java kata.sh ),
  :hidden_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
}
For example: cyberdojo/filesets/kata/Prime Factors/manifest.rb looks like this:
{
  :visible_filenames => %w( instructions ),
}


manifest.rb Parameters
======================
:visible_filenames
  The names of files that will be visible in the editor in the browser at startup.
  Each of these files must exist in the folder.
  The filename cyberdojo.sh should be present (visible or hidden) in one of the 
  manifest.rb files. This is because cyberdojo.sh is the name of the shell file 
  assumed by the ruby code (in the CyberDojo server) to be the start point for  
  running an increment. You can write any actions in the cyberdojo.sh file but 
  clearly any programs it tries to run must be installed on the CyberDojo 
  server. For example, if cyberdojo.sh runs gcc to compile C files then gcc has 
  to be installed. If cyberdojo.sh runs javac to compile java files then javac has 
  to be installed.

:hidden_filenames
  The names of necessary and/or supporting files (if there are any) that 
  are NOT visible in the editor in the browser. Each of these files must exist in 
  the folder. For example, a junit jar file or nunit assemblies. Not needed if
  you do not need hidden files.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the CyberDojo server) used to parse the run-tests 
  output (to see if the increment passes or fails). For example, if the value is 
  'cassert' then app/helpers/run_tests_output_parser.rb must contain a method 
  called parse_cassert() and will be called to parse the output of running the 
  tests via the cyberdojo.sh shell file.

There are two more parameters that can be specified in a manifest.rb
file as part of the inspected ruby object:

{
  :max_run_tests_duration => 20,
  :tab_size => 2,
}

:max_run_tests_duration
  This is the maximum number of seconds the CyberDojo server allows an increment 
  to run in (the time starts after all that increments' files have been copied to 
  the sandbox folder).  This allows players to continue if they accidentally code 
  an infinite loop for example. Reloaded on each increment so it can be modified 
  mid-kata if necessary. Defaults to 10 seconds.

:tab_size
  This is the number of spaces a tab character expands to in the editor textarea.
  Defaults to 4 spaces.


Keyboard-Driver Rotation
========================
By default CyberDojo displays the keyboard-driver rotate page every 5 minutes 
(see app/models/dojo.rb rotation function) which is the cue for the keyboard 
driver at each computer to get up and move to a new computer where they take 
up a non-driver role. 


Dashboard
=========
The dashboard button on the CyberDojo entry page takes you to the dashboard
which shows a continuously updating display of all the avatars traffic light
increments. 


How to Turn off Firefox Spell-Checking
======================================
To turn it off (and avoid annoying red underlines the code editor)
1. Type about:config in the address bar.
2. In the filter field type spell
3. Find the entry for layout.spellcheckDefault and double-click it.
4. Set the integer to 1 to enable the spell checker.
   Set the integer to 0 to disable the spell checker.


How to Turn off Chrome Spell-Checking
=====================================
To turn it off (and avoid annoying red underlines the code editor)
1. Right click in the editor
2. Under Spell-checker Options>
3. Deselect 'Check Spelling in this Field'



Misc Notes
==========
o) http://vimeo.com/15104374 has a video of me doing the Roman Numerals kata in Ruby  
o) http://vimeo.com/8630305 has a video of a very early version of CyberDojo
o) When I started CyberDojo I didn't know any ruby, any rails, or any javascript
   (and not much css or html either). I'm self employed so I've have no-one to 
   pair with (except google) while developing this in my limited spare time. Some 
   of what you find is likely to be non-idiomatic. Caveat emptor!
o) I have worked hard to _remove_ features from CyberDojo. My idea is that the 
   simpler the environment the more players will need to collaborate with each
   other. Remember the aim of a CyberDojo is _not_ to ship something, it is to 
   practice collaborative development.
o) Olve Maudal has been enthusiastic about CyberDojo from the very early days.
   Olve - I really appreciate all your encouragement.


