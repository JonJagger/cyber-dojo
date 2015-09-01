rm -f *.class
CLASSES=.:`ls /junit/*.jar | tr '\n' ':'`
javac -Xlint:unchecked -Xlint:deprecation -cp $CLASSES  *.java
if [ $? -eq 0 ]; then
  # run test classes even if they are inner classes
  # remove voluminous stack trace from output
  java -cp $CLASSES org.junit.runner.JUnitCore `ls -1 *Test*.class | grep -v '\\$' | sed 's/\(.*\)\..*/\1/'` | grep -Ev 'org.junit.runner|org.junit.internal|sun.reflect|org.junit.Assert|java.lang.reflect|org.hamcrest'
fi
