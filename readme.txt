
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
    'unsplice.tests.c' => {},
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

  :unit_test_framework => 'tequila',

  :font_size => 14,

  :tab_size => 8,

  :font_family => 'verdana'
}



Explanation of these parameters
-------------------------------
1:visible_files
  These are the names of the files that are visible in the editor in the browser.
  Each file can have associated information if necessary. In the example
  above the file called kata.sh has a permission of 755 (executable) because it is a shell 
  file - some ruby app code checks if a filename has an associated :permission and if so 
  chmod's the file. 

2:hidden_files
  These are the names of necessary and supporting files (if there are any) that are NOT 
  visible in the editor in the browser (but are required to run-tests on each increment). 
  Again, each file can have associated information. 
  
3:unit_test_framework
  This defines the name of the unit test framework used in the exercise. 
  This name partially determines the name of the ruby function used to
  parse the run-tests output (to see if the increment is red or green).

4:font_size
  This can be set to values not listed in the editArea font-size drop-down list.
  Optional. The default is 14.

5:tab_size
  Optional. The default is 4.

6.font_family
  Optional. The default is monospace. 


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

4. You can choose to make any file visible or hidden. In the example above to have a visible
   makefile you would simply need to move makefile into the :visible_files section.




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
 The :language parameter might also be used in the web editor to select appropriate 
 syntax highlighting.
 The :language parameters and :unit_test_framework parameters (from the exercise manifest)
 are used to select the ruby function to regexp parse the run tests output to determine 
 if the increment is a pass or fail. 
 For example if :language is 'c' and :unit_test_framework is 'assert' then a ruby function
 called parse_c_assert is assumed to exist and is called to parse the output of run-tests>
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
   is saved to its own folder. For example if Norway is playing
   kata 34 then the files submitted for increment 21 (for Norway) 
   will be found in the folder  katas/34/Norway/21/
   There may be some concurrency issues related to this.
o) When I started this (not so long ago) I didn't know any ruby, any rails,
   or any javascript. I'm self employed so I've have no-one to pair with (except google)
   while developing this in my limited spare time. Some of what you find is likely 
   to be non-idiomatic. Caveat emptor!
o) Players should be able to do a kata without identifying themselves.
   There is scope for allowing them to identify themself if they want to but
   it should not be compulsory. This is one of my future design guidelines.
o) Kudos to Christophe Dolivet who wrote editArea which provides the javascript
   tabbed editor. Note however that there appears to be an occasional display bug in editArea 
   when it is trying to do syntax highlighting. You can turn editArea syntax highlighting off   
   by pressing Control-H which refreshes the display. Control-H is a toggle so
   hit it again to turn syntax-highlighting back on.
o) I'd like to thank Olve Maudal of Tandberg for his encouragement.
o) I've promised to run a browser-based dojo at the accu 2010 conference
   which starts April 14th. It would be great if a publically accesible dojo-server 
   was running by then.
o) A VirtualBox image of the server would also be nice.
o) It might appear to be better if the dojo-server assigned a player an animal-identifier 
   instead of the player having to select one manually. However, if the server selects 
   the avatar and you wish to stay as the same avatar on all increments then the server 
   would need to record the identity of the playing computer. I also think it makes sense
   to explicitly choose the avatar so it is less "unexpected" as you start.
   However, suppose you schedule a kata and start it as a Koala, what is to stop 
   another player on a different computer also choosing to start as a koala. This
   will become an issue when players are not co-located.


