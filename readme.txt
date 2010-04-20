
Requirements
============
Ruby
Rails


Installation
============
download the zip file, unzip it, cd into the cyber_dojo directory. Then
  $ script/server -d
  $ open http://localhost:3000
And your cyber-dojo should be running.


Top level folders
=================
o) katalogue/ this folder contains filesets for named katas. For example
   katalogue/c/* might contain files for a blank-start c kata,
   katalogue/ruby_bowling_game might contain ruby files for the bowling game kata.
o) dojos/ each subfolder represents a virtual dojo. For example
   dojos/tandberg is where the devs at tandberg perform their katas,
   dojos/accu-2010 is where the accu-2010 conference katas will be held.
   

Setting up and naming a new kata
================================
Make a katalogue subfolder naming the new kata. For example if you wish
to create a fileset for the battleships kata in java you might create
the folder katalogue/java_battleships
Then put all the starting files for this kata into this folder.
This folder must contain a file called manifest.rb
which must contain an inspected ruby object naming the starting
filenames (it is loaded and eval'd in ruby code in the cyber-dojo server)
in the following format:

{
  :visible_filenames => %w( name.of.one.file
                            name.of.another.file
                            etc.etc
                            kata.sh),

  :hidden_filenames => %w( name.of.hidden.file 
                           name.of.another.hidden.file),

  :unit_test_framework => 'the.name.of.the.unit.test.framework.you.are.using',
}


Explanation of these parameters
-------------------------------
1:visible_filenames
  These are the names of the files that are visible in the editor in the browser.
  Each of these files must exist in the folder.
  The filename kata.sh must be present (visible or hidden) as that is the name 
  of the shell file assumed by the ruby code in the cyber-dojo server to be the 
  start point for running an increment.
  You can write any actions in the kata.sh file but clearly any programs it
  tries to run must be installed on the cyber-dojo server. For example, if kata.sh runs gcc 
  to compile c files then gcc has to be installed. If kata.sh runs javac to compile java
  files then javac has to be installed.

2:hidden_filenames
  These are the names of necessary and supporting files (if there are any) that are NOT 
  visible in the editor in the browser. Each of these files must exist in the folder.
  For example, a junit jar file or nunit assemblies. Optional if empty.
  
3:unit_test_framework
  The name of the unit test framework used.
  This name partially determines the name of the ruby function (in the cyber-dojo server)
  used to parse the run-tests output (to see if the increment passes or fails).
  For example, if the value is 'cassert' then app/helpers/run_tests_output_parser.rb
  must contain a method called parse_cassert() and will be called to parse the output of
  running the tests. 


Setting up and naming a new kata session in a virtual dojo
==========================================================
1. Choose a name for you kata_session, eg ruby_bowling_game
2. Make a folder with this name under the appropriate dojos subfolder on 
   the cyber-dojo server. For example, 
   dojos/accu-2010/ruby_bowling_game
3. Make sure this folder contains a file called kata_manifest.rb
   this file must contain an inspected ruby object defining two parameters
   as follows:

{
  :kata_name => 'ruby_bowling_game',
  :max_run_tests_duration => 10,
}

Explanation of these parameters
-------------------------------
1:kata_name
 Determines the initial kata fileset, for example
   'ruby_bowling_game' --> 'katalogue/ruby_bowling_game/manifest.rb'
 This name does not have to be the same as the name of the kata session itself.

2:max_run_tests_duration
  This is the maximum number of seconds the dojo-server allows an increment to run in
  (the time starts after all the increments files have been copied to the sandbox folder).
  This is reloaded on each increment to allow the sensei to vary the value during the
  kata if necessary.


Notes
=====
o) http://vimeo.com/8630305 has a video of an early version of cyber-dojo
o) The rails code does NOT use a database. Instead each increment
   is saved to its own folder. For example if the Lions are doing
   kata dojos/accu-2010/ruby_bowling_game then the files submitted for increment 21 
   for the Lions will be found in the folder dojos/accu-2010/ruby_bowling_game/Lions/21/
   There may be some concurrency issues related to this.
o) When I started this (not so long ago) I didn't know any ruby, any rails,
   or any javascript. I'm self employed so I've have no-one to pair with (except google)
   while developing this in my limited spare time. Some of what you find is likely 
   to be non-idiomatic. Caveat emptor!
o) I'd like to thank Olve Maudal of Tandberg for his encouragement.


