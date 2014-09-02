
misc
====

katas directory structure
-------------------------
The rails code does *not* use a database.
Instead each practice session lives in a git-like directory structure based
on its full 10 character id.
For example the session with id `82B583C347` lives at
```
  cyberdojo/katas/82/B583C347
```
Each started animal has a sub-directory underneath this, eg
```
  cyberdojo/katas/82/B583C347/wolf
```
Each started animal has a sandbox sub-directory where its files are held, eg
```
  cyberdojo/katas/82/B583C347/wolf/sandbox
```


git repositories
----------------
Each started animal has its own git respository, eg
```
  cyberdojo/katas/82/B583C347/wolf/.git
```
The starting files (as loaded from the `cyberdojo/katas/82/B583C347/wolf/manifest.json`
file) form tag 0 (zero). Each `[test]` event causes a new git commit and tag, with a
message and tag which is simply its number. For example, the fourth time the wolf
computer presses `[test]` causes
```
$ git commit -a -m '4'
$ git tag -m '4' 4 HEAD
```
From an animal's directory you can issue the following commands:
To look at filename for tag 4
```
$ git show 4:sandbox/filename
```
To look at filename's differences between tag 4 and tag 5
```
$ git diff 4 5 sandbox/filename
```
It's much easier and more informative to just click on a traffic light
from the test page or the dashboard page.


disk space
----------
cyber-dojo is very heavy on inodes. You will probably
run out of inodes before running out of disk space. The folder that eats
the inodes is `cyberdojo/katas/`



turning off spell-checking in your browser
------------------------------------------
and avoid annoying red underlines in the code editor...
<br>In Chrome
  * Right click in the editor
  * Under Spell-checker Options>
  * Deselect 'Check Spelling in this Field'

In Opera/Firefox
  * Right click in the editor
  * Deselect 'Check spelling'



notes
-----
  * https://vimeo.com/104548135 has a video of me doing the Roman Numerals
   exercise in Ruby in cyber-dojo
  * When I started cyber-dojo I didn't know any ruby, any rails, or any
   javascript (and not much css or html either). I'm self-employed so
   I've have no-one to pair with (except google) while developing this
   in my limited spare time. Some of what you find is likely to be
   non-idiomatic. Caveat emptor!
  * I work hard to *remove* features from cyber-dojo.
   The simpler the environment the more players will concentrate on
   the practice and the more they will need to collaborate with each other.
   Remember the aim of a cyber-dojo is *not* to ship something!
   The aim of cyber-dojo is to deliberately practice developing software
   collaboratively.


thank you
---------
  * Olve Maudal, Mike Long and Johannes Brodwall have been enthusiastic about
   cyber-dojo and have provided lots of help right from the very early days.
   Mike Sutton and Michel Grootjans too. Olve, Mike, Johannes, Mike and
   Michel - I really appreciate all your help and encouragement.
  * James Grenning uses cyber-dojo a lot, via his own Turnkey S3 cloud servers,
   and has provided awesome feedback and made several very generous donations.
   Thank you James.
  * Jerry Weinberg showed me the power of experiential learning on all
   of his courses and conferences, notably PSL,
   http://www.estherderby.com/problem-solving-leadership-psl
   which strongly influenced the way I designed cyber-dojo.
   Thank you Jerry.
