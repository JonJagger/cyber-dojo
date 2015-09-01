rm -f *.class
CLASSES=.:`ls /approval/*.jar | tr '\n' ':'`
javac -Xlint:unchecked -cp $CLASSES *.java
if [ $? -eq 0 ]; then
  java -cp $CLASSES org.junit.runner.JUnitCore `ls -1 *Test*.class | sed 's/\(.*\)\..*/\1/'`
fi
