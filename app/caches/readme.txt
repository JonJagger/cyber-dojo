
The caches/ folder holds three specific cache files as detailed below.
These are created on-demand at the first use from within the web server.


runner_cache.json
-----------------
The docker runners, eg lib/docker_tmp_runner.rb each have a cache
related to which docker-images have been pulled and are *already* present
and usable on the server (and possibly on which node they reside)
It is NOT the case that the create languages+test page lists *all* the languages+tests
and when you press test the language+tests's docker image is pulled on demand.
That would be too slow.


languages_cache.json
--------------------
There are three crucial pieces of information per language+test.
1. It's display-name,
   eg "Ruby, RSpec"
   To the left of the comma is the name of the language.
   To the right of the comma is the name of the test framework.
   These two names appear in create choose-language+test page lists.
2. It's folder under languages/
   eg languages/Ruby1.9.3/Rspec
   This is where the manifest.json file lives.
3. It's image-name
   eg cyberdojofoundation/java_junit
   This is the name of its docker image

The display-name is stored in each started cyber-dojo's manifest.json file,
with the comma replaced by a dash. For example
katas/5E/15035DDC/manifest.json --> { ...  "language":"Ruby-Rspec" ... }

The server maps "Ruby-Rspec" to the "languages/Ruby1.9.3/Rspec" so it can
create an app/models/language.rb object for it and hence know its
display-name and image-name from its manifest.json file.

Note that the display-name is decoupled from its associated languages/
sub-folder. This means, for example, that a language+test can be upgraded
and live in a new sub-folder, and if you fork from a cyber-dojo practice
session started on the older version, the forked practice session
will pick up the upgraded language+test.

The languages_cache.json maps from the display-name to
1. the language dir
2. the test dir
3. the image name
caches/languages_cache.json, app/models/languages.rb, and app/models/language.rb
are designed so that the create choose-language+test page gets all the information it
needs to display the languages and tests list via a *single* disk access.


exercises_cache.json
--------------------
This is a simple cache of each exercise's
1. folder-name
2. instructions file content
Again this allows the create page choose-exercise to get all the information it needs
to display the exercises list and their instructions via a *single* disk access.


