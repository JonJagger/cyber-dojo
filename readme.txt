
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



Setting up a new exercise
=========================
Make a folder for the name of the exercise. For example if the exercise is called
unsplice and is a c exercise then create a folder called unsplice in a folder called
c in the exercises folder; 'exercises/c/unsplice/'
Then place the files required for the exercise in this folder as 
follows. First, the folder must contain a file called exercise_manifest.rb
This file contains an inspected ruby object defining the exercise parameters (it is
loaded and eval'd in the ruby code). For example:

{
  :visible_files =>
  {
    'unsplice.tests.c' => { :preloaded => true },
    'unsplice.c' => {},
    'unsplice.h' => {},
    'notes.txt' => {},
    'instructions' => {},
    'makefile' => {},
    'kata.sh' => { :permissions => 0755 },
  },

  :hidden_files =>
  {
  },

  :unit_test_framework => 'assert',

  :font_size => 14,
  :font_family => 'monospace'
  :font_weight => 'normal',
  :color => 'white',
  :background_color => '#686868',
}



Explanation of these parameters
-------------------------------
1:visible_files
  These are the names of the files that are visible in the editor in the browser.
  Each file can have associated information if necessary. In the example
  above the file called kata.sh has a permission of 755 (executable) because it is a shell 
  file - some ruby app code checks if a filename has an associated :permission and if so 
  chmod's the file. 
  Any visible file with :preloaded => true will be pre-loaded into the editor
  when the browser page first opens.

2:hidden_files
  These are the names of necessary and supporting files (if there are any) that are NOT 
  visible in the editor in the browser (but are required to run-tests on each increment). 
  Again, each file can have associated information. 
  
3:unit_test_framework
  This defines the name of the unit test framework used in the exercise. 
  This name partially determines the name of the ruby function used to
  parse the run-tests output (to see if the increment is red or green).

4.1:font_size
  Optional (css pt size value), default is '14'
4.2:font_family
  Optional (css value), default is 'monospace' 
4.3:font_weight
  Optional (css value), default is 'normal'
4.4:color
  Optional (css value), default is 'white'
4.5:background_color
  Optional (css value), default is '#686868'



Some Notes
----------
1. The filename kata.sh must be present (visible or hidden) as that is the name 
   of the shell file assumed by the ruby app code in the dojo server to be the start point 
   for running an increment.

2. As well as containing the file exercise_manifest.rb the exercise folder must also contain
   all the files named in both the hidden_files section and the visible_files section.

3. You can write any actions in the kata.sh file but clearly any programs it
   tries to run must be installed on the dojo-server. For example, if kata.sh runs gcc to compile
   c files then gcc has to be installed. If kata.sh runs javac to compile java
   files then javac has to be installed.

4. You can choose to make any file visible or hidden. In the example above to have a hidden
   makefile you would simply need to move makefile into the :hidden section.




Setting up a new kata
=====================
This currently has to be done manually. 

1. Choose a kata-id, eg 789

2. Make a folder with this id under the katas folder on the dojo server.

3. Make sure this folder contains a file called kata_manifest.rb
   this file must contain an inspected ruby object defining the chosen exercise. For example:

{
  :language => 'c',
  :exercise => 'unsplice',
  :max_run_tests_duration => 10,
}

Explanation of these parameters
-------------------------------

1:language
2:exercise
 These two parameters define the name of the language and the name of the exercise.
 Together these parameters determine the exercise-folder, eg 'exercises/c/unsplice'
 The :language parameter and :unit_test_framework parameter (from the exercise manifest)
 are used to select the ruby function to regexp parse the run tests output to determine 
 if the increment is a pass or fail. 
 For example if :language is 'c' and :unit_test_framework is 'assert' then a ruby function
 called parse_c_assert is assumed to exist and is called to parse the output of running the tests.
 If you use a new unit test framework you will need to add a new regexp'ing ruby function.

3:max_run_tests_duration
  This is the maximum number of seconds the dojo-server allows an increment to run in
  (the time starts after all the increments files have been copied to the sandbox folder).
  This is reloaded on each increment to allow the sensei to vary it's value during the
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


