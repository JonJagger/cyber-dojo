
================================================
   VERY VERY IMPORTANT - VERY VERY IMPORTANT
================================================
CyberDojo clients have full rights on the 
CyberDojo server. You are strongly advised to
run the CyberDojo server inside a virtual box.
================================================


Requirements
============
Ruby
Rails

Here are the commands I used to install ruby and rails onto my Ubuntu server:
>sudo aptitude install ruby build-essential libopenssl-ruby ruby1.8-dev
>sudo apt-get install apache2 apache2-mpm-prefork apache2-prefork-dev
>sudo apt-get install rubygems
I then added this line
export PATH=/var/lib/gems/1.8/bin:$PATH
to end of ~/.bashrc
>sudo gem install rails -v2.3.4
>sudo apt-get install libsqlite3-dev
>sudo gem install sqlite3-ruby

There appears to be a potential rails version issue. The CyberDojo servers I 
have built explicitly specified the version during installation as above.



Installation
============
After getting the sourcecode from GitHub cd into the cyberdojo directory. Then
  $ script/server -d
  $ open http://localhost:3000
And your CyberDojo should be running. There are no requirements on the
clients (except of course a browser). I also install and use apache on my
CyberDojo server but that is optional.



What will work and what won't work
==================================
Initial filesets for six languages are provided: C, C++, C#, Java, Python and 
Ruby. Whether you will be able to compile successfully in any of these languages
of course depends on whether these languages are installed on your CyberDojo 
server or not. Ubuntu comes with built-in support for C, C++, and Python and you 
need Ruby for the CyberDojo server itself. 
I installed support for Java as follows
>sudo apt-get install sun-java6-sdk
(when asked, press tab to select ok, and hit enter to continue)
I installed support for C# as follows
>sudo apt-get install mono-gmcs
>sudo apt-get install nunit-console



Dojos
=====
Each subfolder underneath cyberdojo/dojos/ represents a virtual dojo. 
For example cyberdojo/dojos/xp2010/ is where I put the xp2010 CyberDojo 
conference. If there is a single subfolder in cyberdojo/dojos/ the 
CyberDojo server will take you straight into it without asking. If 
there are multiple subfolders in cyberdojo/dojos/ the CyberDojo server 
will ask you to select one.


Avatars
=======
Once you have chosen your dojo the CyberDojo server will ask you to choose 
o) your animal avatar  (eg Pandas)
   The avatar provides identity for each laptop participating in the kata. 
   If a laptop has to retire during a kata a new laptop can easily replace it.
o) your language (eg C++)
   Each language corresponds to a subfolder of cyberdojo/languages/
o) your kata (eg Prime Factors)
   Each kata corresponds to a subfolder of cyberdojo/katas/


Adding a new language
=====================
Create a new subfolder under cyberdojo/languages/
Create a manifest.rb file in this folder (see below)


Adding a new kata
=================
Create a new subfolder under cyberdojo/katas/
Create a manifest.rb file in this folder (see below)


Manifests
=========
The two manifest.rb files contains inspected ruby objects. 
For example: cyberdojo/languages/Java/manifest.rb looks like this:
{
  :visible_filenames => %w( Untitled.java UntitledTest.java kata.sh ),
  :hidden_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
}
For example: cyberdojo/katas/Prime Factors/manifest.rb looks like this:
{
  :visible_filenames => %w( instructions ),
}


Manifest Parameters
===================
:visible_filenames
  The names of files that will be visible in the editor in the browser at startup.
  Each of these files must exist in the folder.
  The filename cyberdojo.sh should be present (visible or hidden) in one of the 
  manifest.rb files. This is because cyberdojo.sh is the name of the shell file 
  assumed by the ruby code in the CyberDojo server to be the start point for  
  running an increment. You can write any actions in the cyberdojo.sh file but 
  clearly any programs it tries to run must be installed on the CyberDojo 
  server. For example, if cyberdojo.sh runs gcc to compile C files then gcc has 
  to be installed. If cyberdojo.sh runs javac to compile java files then javac has 
  to be installed.

:hidden_filenames
  The names of necessary and supporting files (if there are any) that 
  are NOT visible in the editor in the browser. Each of these files must exist in 
  the folder. For example, a junit jar file or nunit assemblies. Not needed if
  you do not need hidden files.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the CyberDojo server) used to parse the run-tests 
  output (to see if the increment passes or fails). For example, if the value is 
  'cassert' then app/helpers/run_tests_output_parser.rb must contain a method 
  called parse_cassert() and will be called to parse the output of running the 
  tests via the cyberdojo.sh shell script file.

There are two more parameters that can be specified in a manifest.rb
file as part of the inspected ruby object:

{
  :max_run_tests_duration => 20,
  :tab_size => 2,
}

:max_run_tests_duration
  This is the maximum number of seconds the CyberDojo server allows an increment 
  to run in (the time starts after all the increments files have been copied to 
  the sandbox folder). This is reloaded on each increment so it can be modified 
  mid-kata if necessary. Defaults to 10 seconds.

:tab_size
  This is the number of spaces a tab character expands to in the editor textarea.
  Defaults to 4 spaces.


Dojo Dashboard Display
======================
http://ip-address:port/dashboard
will give you an auto-updating display of the current colour and history 
(red, green, or yellow for each increment) of every avatar in a selected dojo


Repeating Alarm
===============
I run a CyberDojo by sounding an alarm every 4-5 minutes or so which
is the cue for the keyboard driver at each computer to get up and move
to a new computer where they take up a non-driver role.
You may be able to do this using
http://ip-address:port/alarm


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
o) http://vimeo.com/8630305 has a video of a very early version of CyberDojo
o) The rails code does NOT use a database. Instead each increment is saved to
   its own folder. For example if the Wolves are doing kata in the xp2010 
   CyberDojo then the files submitted for their increment 21 will be found in 
   the folder 
     cyberdojo/dojos/xp2010/wolves/21/
o) When I started CyberDojo I didn't know any ruby, any rails, or any javascript
   (and not much css or html either). I'm self employed so I've have no-one to 
   pair with (except google) while developing this in my limited spare time. Some 
   of what you find is likely to be non-idiomatic. Caveat emptor!
o) I have worked hard to _remove_ features from CyberDojo. My idea is that the 
   simpler the environment the more players will need to collaborate with each
   other. Remember the aim of a CyberDojo is not to ship something, it is to 
   practice collaborative development.
o) Olve Maudal has been enthusiastic about CyberDojo from the very early days.
   Olve - I really appreciate all your encouragement.


