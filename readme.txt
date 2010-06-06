
Requirements
============
Ruby
Rails


Installation
============
download the zip file, unzip it, cd into the cyber_dojo directory. Then
  $ script/server -d
  $ open http://localhost:3000
And your CyberDojo should be running. There are no requirements on the
clients (except of course a browser).



Dojos
=====
Each subfolder underneath cyberdojo/dojos represents a virtual dojo. 
For example cyberdojo/dojos/xp2010 is where I put the xp2010 CyberDojo conference.
If there is a single subfolder in cyberdojo/dojos/ the CyberDojo server will 
take you straight into it without asking. If there are multiple subfolders  
in cyberdojo/dojos/ the CyberDojo server will ask you to select one.


Avatars
=======
Once you have chosen your dojo the CyberDojo server will ask you to choose your
animal avatar by selecting its image (eg Pandas). The avatar provides identity for
each laptop participating in the kata. For example, if a laptop has to be retired
during a kata a new laptop can easily replace it.


Katas
=====
Each subfolder underneath the selected dojo folder represents a kata.
For example cyberdojo/dojos/xp2010/ruby_phone_list is where I put the Ruby phone_list
kata at the xp2010 CyberDojo conference.


Kata Manifest
=============
Each kata folder must contain a file called kata_manifest.rb
This file must contain an inspected ruby object. 
For example: cyberdojo/dojos/xp2010/ruby_phone_list/kata_manifest.rb
{
  :file_set_names => [ 'languages/java',
                       'katas/bowling_game' ]
}

Explanation
- - - - - - 
:file_set_names
  The names of the initial kata filesets. For example
    'languages/java'     --> 'katalogue/languages/java/manifest.rb'
    'katas/bowling_game' --> 'katalogue/katas/bowling_game/manifest.rb'


File Set Manifests
==================
The file set manifests named in manifest.rb also contain an inspected ruby
object. 
For example: katalogue/languages/java/manifest.rb
{
  :visible_filenames => %w( Untitled.java UntitledTest.java kata.sh ),
  :hidden_filenames => %w( junit-4.7.jar ),
  :unit_test_framework => 'junit',
}

Explanation
- - - - - - 
:visible_filenames
  The names of files that are visible in the editor in the browser.
  Each of these files must exist in the folder.
  The filename kata.sh must be present (visible or hidden) as that is the name 
  of the shell file assumed by the ruby code in the CyberDojo server to be the 
  start point for running an increment.
  You can write any actions in the kata.sh file but clearly any programs it
  tries to run must be installed on the CyberDojo server. For example, if kata.sh 
  runs gcc to compile c files then gcc has to be installed. If kata.sh runs javac 
  to compile java files then javac has to be installed.
  All visible_filenames from all file-sets in a single kata_manifest will be 
  loaded at the start of the kata.

:hidden_filenames
  The names of necessary and supporting files (if there are any) that 
  are NOT visible in the editor in the browser. Each of these files must exist in 
  the folder. For example, a junit jar file or nunit assemblies. Not needed if
  you do not need hidden files.
  All hidden_filenames from all file-sets in a single kata_manifest will be
  available for use in the kata.sh commands.
  
:unit_test_framework
  The name of the unit test framework used. This name partially determines the 
  name of the ruby function (in the CyberDojo server) used to parse the run-tests 
  output (to see if the increment passes or fails). For example, if the value is 
  'cassert' then app/helpers/run_tests_output_parser.rb must contain a method 
  called parse_cassert() and will be called to parse the output of running the 
  tests via the kata.sh shell script file.


Further parameters
------------------
There are two more parameters that can be specified in either manifest file
as part of the inspected ruby object:

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
  Default to 4 spaces.


What will work and what won't work
==================================
After selecting an animal avatar (eg Pandas) the initial virtual dojo is currently 
set up with five katas containing untitled files for C, C++, C#, Java, and Ruby. 
Whether you will be able to compile succesfully in any of these katas (except Ruby)
depends on whether these languages are installed on your CyberDojo server.


Notes
=====
o) http://vimeo.com/8630305 has a video of a very early version of CyberDojo
o) The rails code does NOT use a database. Instead each increment is saved to
   its own folder. For example if the Wolves are doing kata
   dojos/xp2010/ruby_bowling_game then the files submitted for increment 21 
   for the Wolves will be found in the folder 
     dojos/xp2010/ruby_bowling_game/Wolves/21/
o) When I started CyberDojo I didn't know any ruby, any rails, or any javascript
   (and not much css or html either). I'm self employed so I've have no-one to 
   pair with (except google) while developing this in my limited spare time. Some 
   of what you find is likely to be non-idiomatic. Caveat emptor!
o) I'd like to thank Olve Maudal of Tandberg for his encouragement.




