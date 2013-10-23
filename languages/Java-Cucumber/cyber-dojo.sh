rm -f *.class
CLASSES=.:`ls *.jar | tr '\n' ':'`
javac -cp $CLASSES  *.java   
if [ $? -eq 0 ]; then
  java -cp $CLASSES org.junit.runner.JUnitCore RunCukesTest
fi


