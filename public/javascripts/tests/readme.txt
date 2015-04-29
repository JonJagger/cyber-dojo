
From the cyber-dojo/public/javascripts/tests folder
>source .bashrc
>java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --port 4224 &

Now capture the browsers - localhost:4224. Then to run the tests...

>java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --tests all
If this succeeds you can generate coverage stats
>./genhtml -o coverage coverage/jsTestDriver.conf-coverage.dat 
you can do both steps using the
>./run.sh
which will create the file
  cyber-dojo/public/javascripts/tests/coverage/index.html
open this in a browser and click on the
  javascripts
link on the lhs to open a page containing coverage of all
the cyber-dojo*.js files, each one as a hyperlink


NB: I installed genhtml from  http://ltp.sourceforge.net/coverage/lcov.php
    and then clicked lcov-1.10.tar.gz and then unzipped it
    and then grabbed lcov-1.10/bin/gehtml (its a perl file)


Issue
-----
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
