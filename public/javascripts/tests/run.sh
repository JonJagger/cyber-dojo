source .bashrc
java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.3d.jar --testOutput coverage --tests all
./genhtml -o coverage coverage/jsTestDriver.conf-coverage.dat 
