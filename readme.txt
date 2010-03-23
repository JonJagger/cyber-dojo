
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



Setting up a new language fileset
=================================
Make a folder for the name of the language fileset. For example the initial
set of files for a ruby kata are in languages/ruby/*
The folder must contain a file called exercise_manifest.rb
which must contain an inspected ruby object naming the files (it is
loaded and eval'd in the ruby code). For example:

{
  :visible_files =>
  {
    'source.tests.c' => {},
    'source.c' => {},
    'source.h' => {},
    'makefile' => {},
    'kata.sh' => {},
  },

  :hidden_files =>
  {
  },

  :unit_test_framework => 'assert',
}



Explanation of these parameters
-------------------------------
1:visible_files
  These are the names of the files that are visible in the editor in the browser.
  Each of these files must exist in the folder.
  The filename kata.sh must be present (visible or hidden) as that is the name 
  of the shell file assumed by the ruby app code in the dojo server to be the start point 
  for running an increment.
  You can write any actions in the kata.sh file but clearly any programs it
  tries to run must be installed on the dojo-server. For example, if kata.sh runs gcc to compile
  c files then gcc has to be installed. If kata.sh runs javac to compile java
  files then javac has to be installed.

2:hidden_files  (optional)
  These are the names of necessary and supporting files (if there are any) that are NOT 
  visible in the editor in the browser (but are required to run-tests on each increment). 
  For example, the junit jar file. Each of these files must exist in the folder.
  Optional if empty.
  
3:unit_test_framework
  The name of the unit test framework used. 
  This name partially determines the name of the ruby function used to
  parse the run-tests output (to see if the increment is red or green).



Setting up a new kata
=====================
This currently has to be done manually. 

1. Choose a kata-id, eg 789

2. Make a folder with this id under the katas folder on the dojo server.

3. Make sure this folder contains a file called kata_manifest.rb
   this file must contain an inspected ruby object defining two parameters
   as follows:

{
  :language => 'c',
  :max_run_tests_duration => 10,
}

Explanation of these parameters
-------------------------------

1:language
 Determines the initial language fileset, eg 'c' --> 'languages/c/*'
 The :language parameter and :unit_test_framework parameter (from the exercise manifest)
 are used to select the ruby function to regexp parse the run tests output to determine 
 if the increment is a pass or fail. 
 For example if :language is 'c' and :unit_test_framework is 'assert' then a ruby function
 called parse_c_assert is assumed to exist and is called to parse the output of running the tests.
 If you use a new unit test framework you will need to add a new regexp'ing ruby function.

2:max_run_tests_duration
  This is the maximum number of seconds the dojo-server allows an increment to run in
  (the time starts after all the increments files have been copied to the sandbox folder).
  This is reloaded on each increment to allow the sensei to vary the value during the
  kata if necessary.


Notes
=====
o) Watching http://vimeo.com/8630305 will probably help.
o) The rails code does NOT use a database. Instead each increment
   is saved to its own folder. For example if the Lions are doing
   kata 34 then the files submitted for increment 21 (for the Lions) 
   will be found in the folder  katas/34/Lions/21/
   There may be some concurrency issues related to this.
o) When I started this (not so long ago) I didn't know any ruby, any rails,
   or any javascript. I'm self employed so I've have no-one to pair with (except google)
   while developing this in my limited spare time. Some of what you find is likely 
   to be non-idiomatic. Caveat emptor!
o) Players should be able to do a kata without identifying themselves.
   There is scope for allowing them to identify themself if they want to but
   it should not be compulsory. This is one of my future design guidelines.
o) I'd like to thank Olve Maudal of Tandberg for his encouragement.
o) I've promised to run a browser-based dojo at the accu 2010 conference
   which starts April 14th. It would be great if a publically accesible dojo-server 
   was running by then.
o) A VirtualBox image of the server would also be nice.
o) The dojo-server could possibly assign avatars to computers rather than
   participants having to manually select their avatar. For now I am leaving the
   avatar selection as a manual step because my main aim is to run the dojo
   in a room where all participants are present. 


