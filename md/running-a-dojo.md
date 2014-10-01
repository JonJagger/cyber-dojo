
running a programming dojo
==========================

creating your programming dojo
------------------------------
  * click the `[create]` button
  * click your chosen (language,unit-test-framework) combination, eg `C++,GoogleTest`
  * click your chosen exercise, eg `Prime Factors`
  * click the `[create]` button
  * you'll get a case-insensitive 6-character hex-id. The full id is ten
    characters long (in the URL) but 6 is enough for uniqueness.


entering your programming dojo
------------------------------
  * on *each* participating computer...
  * enter the dojo's 6-character id into the green input box
  * click the `[enter]` button
  * a dialog will appear telling you which animal you are (eg Panda).
  * click `[ok]` to dismiss the dialog
  * a new test page/tab will open in your browser
  * edit the test files...
  * edit the code files...
  * press the `[test]` button
  * a new traffic-light appears at the top, left-to-right, oldest-to-newest
    indicating the result of the test (see below).
  * you can click on any traffic-light to open a diff/revert/fork dialog.
    The dialog shows the diffs between any two traffic-lights
    and has << < > >> buttons to navigate backwards and forwards.
    The dialog also has a `[revert]` button to revert back
    to the files from any traffic-light.
    The dialog also has a `[fork]` button to fork a new
    programming dojo with a new ID.

You can also re-enter at any animals' most recent traffic-light by pressing
the `[re-enter]` button (from the home page) and then clicking the animal.
This is occasionally useful if one computer has to replace another (eg
if your doing an evening dojo and someone has to leave early).

### traffic lights

The result of pressing the `[test]` button is displayed in the `output` file
and also as a new traffic-light (at the top).
Each traffic-light is coloured as follows:
  * red   - tests ran but at least one failed
  * amber - syntax error somewhere, tests not run
  * green - tests ran and all passed

The colours on the traffic-light are positional:
  * red at the top,
  * amber in the middle,
  * green at the bottom.
This means you can still read the display if you are colour blind.

You will also get an amber traffic-light if the tests do not complete
on the cyber-dojo server within 15 seconds (eg you've accidentally coded
an infinite loop or the server is overloaded with too many concurrent
programming dojos).

You will also get an amber traffic-light if you lose the network connection
to the cyber-dojo server (30 second timeout).

Remember, clicking on any traffic-light opens the history dialog showing the
diffs for that traffic-light for that animal together with << < > >> buttons to
navigate backwards and forwards, revert, or fork.


reviewing your programming dojo
-------------------------------
You can get to the dashboard page in two ways:

  * from the home page, enter the dojo's id and click the `[review]` button.
  * from the test page, click the animal image

Each horizontal row corresponds to one animal and displays, from left to right:

  * oldest-to-newest traffic lights
  * total number of traffic-lights (in the current colour).
  * a pie-chart indicating the total number of red,amber,green traffic-lights
    so far.
  * the animal
  * as always clicking on any traffic-light opens a dialog showing the diffs for
    that traffic-light for that animal together with << < > >> buttons to
    navigate backwards and forwards, or fork (revert is only available from
    test page traffic-light dialogs).

### auto refresh?

The dashboard page auto-refreshes every 10 seconds. As more and more tests
are run, more and more traffic-lights appear taking up more and more
horizontal space. These traffic-lights auto scroll:
  * old ones are scrolled out of view to the left
  * the animal image is always visible to the right.

Advice:
  * Project the dashboard *during* the dojo
  * Leave auto-refresh on *during* the dojo
  * Turn auto-refresh *off* just before starting the review.

### time gaps?

When this is checked each vertical column corresponds to 60 seconds
and contains all the traffic-lights created by all the animals in those 60
seconds. If no animals press their `[test]` button during those 60 seconds the
column will contain no traffic-lights at all (instead it will contain
a single dot and be very thin).
When not checked the traffic-lights of different animals are not
vertically time-aligned.

### progress

If available this displays slightly more information about the current
traffic-light of each animal, usually the number of passing and failing
tests.

### duration

This displays how long the dojo has been going (and updates every
10 seconds). The start time is *not* the time dojo was created, but the
time the first animal manually presses their `[test]` button. This allows
you to prepare specific dojos ahead of time.

### team progress

This displays:
  * a pie chart showing the % of all traffic-lights at red, green, and amber.
  * the number of animals currently at red, if any, (in red)
  * the number of animals currently at amber, if any, (in amber)
  * the number of animals currently at green, if any, (in green)


reviewing the history
---------------------
Clicking on any traffic-light opens the history dialog showing the diffs for that
traffic-light for that animal.

By default, the diff between two successive traffic-lights is displayed.
For example, suppose you have 65 traffic lights and you click on the 42nd one -
the history dialog will display the diff between traffic-lights 41 and 42
(and the number 42 will appear between the << < and the > >> controls).

Navigating using the << < > >> buttons
  * << moves backward to the first traffic-light, displaying the diff of 0 <-> 1
  * <  moves backward one traffic-light, displaying the diff of 40 <-> 41
  * >  moves forward one traffic-light, displaying the diff of 42 <-> 43
  * >> moves forward to the last traffic-light (eg 65), displaying the diff of 64 <-> 65

As you navigate forwards and backwards using
the << < > >> buttons the server will stay on the same file if it continues to
have a diff. If it cannot do this (because the file has been renamed or
deleted or has not changed) the server will open the file with the most changes.
When a file is initially opened it autoscrolls to that file's first diff-chunk.
Reclicking on the filename auto-scrolls to the next diff-chunk in the file.
Clicking the red number-of-lines-deleted button (to the right of the filename)
will toggle the deleted lines on/off for that file's diff.
Clicking the green number-of-lines-added button (to the right of the filename)
will toggle the added lines on/off for that file's diff.

You can also do a "no-diff", showing exactly how the files were for the
traffic light, by simply unchecking the diff? checkbox.
The << < > >> continue to work, and will continue to show a "no-diff".
