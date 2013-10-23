rm -f *Test*.class
CLASSES=.:`ls *.jar | tr '\n' ':'`
javac -cp $CLASSES *.java 
if [ $? -eq 0 ]; then
  java -cp $CLASSES org.junit.runner.JUnitCore `ls -1 *Test*.class | sed 's/\(.*\)\..*/\1/'`
fi