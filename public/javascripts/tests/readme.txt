
From the cyberdojo/public/javascripts/tests folder
>source .basrc
>java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --port 4224 &

Now capture the browsers - localhost:4224. Then to run the tests...

>java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --tests all

