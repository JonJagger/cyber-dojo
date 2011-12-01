
From the cyberdojo/public/javascripts/tests folder
>source .basrc
>java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --port 4224 &

Now capture the browsers - localhost:4224. Then to run the tests...

>java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --tests all

The tests run and I get an overall % coverage.
However...

Issue 1
-------
I'm not getting coverage files.

Issue 2
-------
I get the following output
line 217:6 mismatched input 'class' expecting RBRACE
line 218:5 no viable alternative  at input ')'
line 256:0 no viable alternative  at input '}'
Googling finds this
http://code.google.com/p/js-test-driver/issues/detail?id=50
<quote>
Turns out that JsTestCoverage does not like files that are 
encoded in Unicode.  I saved the files in ANSI format, and the "Line 0:0 no viable 
character at ' ' " error disappeared.
</quote>
