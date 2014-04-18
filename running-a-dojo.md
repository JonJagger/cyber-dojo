
running a programming dojo
==========================

creating your programming dojo
------------------------------
  * click the `[create]` button
  * click your chosen language|unit-test-framework, eg `C++|assert`
  * click your chosen exercise, eg `Prime Factors`
  * click the `[ok]` button
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
  * a new traffic-light appears
  * traffic-lights progress along the top, left-to-right, oldest-to-newest
  * clicking on any traffic-light opens a dialog showing the diffs for
   that traffic-light plus << < > >> buttons to navigate forwards and backwards

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

The colours on the traffic-light are positional, red at the top,
amber in the middle, green at the bottom. This means you can still read the
display if you are colour blind.
You will also get an amber traffic-light if the tests do not complete within
15 seconds (eg you've accidentally coded an infinite loop or the server is
overloaded with too many concurrent programming dojos)
Clicking on any traffic-light opens a dialog showing the diffs for
that traffic-light for that animal together with << < > >> buttons to
navigate forwards and backwards.


reviewing your programming dojo
-------------------------------
You can get to the dashboard page in two ways
  * from the home page, enter the dojo's id and click the `[review]` button.
  * from the test page, click the animal image at the top right

Each horizontal row corresponds to one animal and displays, from left to right,
  * its oldest-to-newest traffic lights
  * its total number of red,amber,green traffic-lights so far (in red,amber,green).
  * its total number of traffic-lights (in the current colour).
  * its animal
  * as always clicking on any traffic-light opens a dialog showing the diffs for
    that traffic-light for that animal together with << < > >> buttons to
    navigate forwards and backwards.

### auto refresh?

The dashboard page auto-refreshes every 10 seconds. As more and more tests
are run, more and more traffic-lights appear taking up more and more
horizontal space. These traffic-lights auto scroll:
  * old ones are scrolled out of view to the left
  * the animal image is always visible to the right.

The idea is to leave auto-refresh on *during* the dojo
and to turn it *off* just before starting a dashboard review.


### |60s| columns?

When this is checked each vertical column corresponds to 60 seconds
and contains all the traffic-lights created by all the animals in those 60
seconds. If no animals press the `[test]` button during those 60 seconds the
column will contain no traffic-lights at all (instead it will contain
a single dot and be very thin).
When not checked the traffic-lights of different animals are not
vertically time-aligned.


replaying the diffs
-------------------
Clicking on any traffic-light opens a dialog showing the diffs for that
traffic-light for that animal. As you navigate forwards and backwards using
the << < > >> buttons the server will stay on the same file if it continues to
have a diff. If it cannot do this (because the file has been renamed or
deleted or has not changed) the server will open the file with the most changes.
When a file is initially opened it autoscrolls to that file's first diff-chunk.
Reclicking on the filename auto-scrolls to the next diff-chunk in the file.
Clicking the red number-of-lines-deleted button (to the right of the filename)
will toggle the deleted lines on/off for that file's diff.
Clicking the green number-of-lines-added button (to the right of the filename)
will toggle the added lines on/off for that file's diff.

The diff is a diff between two traffic-lights. If you click on an animals 13th
traffic-light the diff dialog shows the diff between traffic-lights 12 and 13,
and 12 and 13 appear at the top left next to their respective traffic-lights.
You can show the diff between any two traffic-lights by simply editing these
numbers. For example, if you edit the 13 to a 15 and press return the dialog
will update to display the diff between traffic-lights 12 and 15.
Below the two traffic-lights are  <<  <  >  >>  buttons.
These buttons move forwards and backwards whilst maintaining the traffic-light
gap (eg 12 <-> 15 == 3).

For example, pressing
  * << moves back to the first traffic-light, so if the gap is 3
    it will display the diff of 1 <-> 4
  * <  moves one traffic-light back, so if the gap is 3
    it will display the diff of 11 <-> 14
  * >  moves one traffic-light forward, so if the gap is 3
    it will display the diff of 13 <-> 16
  * >> moves forward to the last traffic-light (eg 65), so if the gap is 3
    it will display the diff of 62 <-> 65

You can also do a "no-diff" by simply entering the same value (eg 23) twice.
23 <-> 23 will display all the files from traffic-light 23 and there will be
no diffs at all. The  << < > >> buttons still work and maintain the "no-diff".
Eg pressing the < button will move back one traffic-light and show the diff
of traffic-lights 22 <-> 22, viz, the files from traffic-light 22.
