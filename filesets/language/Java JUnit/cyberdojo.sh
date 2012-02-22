javac -cp .:./junit-4.7.jar *.java 
if [ $? -eq 0 ]; then
  java -cp .:./junit-4.7.jar org.junit.runner.JUnitCore `ls -1 *Test*.class | sed 's/\(.*\)\..*/\1/'`
fi

