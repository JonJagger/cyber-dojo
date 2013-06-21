javac -cp .:./junit-4.11.jar *.java 

if [ $? -eq 0 ]; then
  java -cp .:./junit-4.11.jar org.junit.runner.JUnitCore `ls -1 *Test*.class | grep -v '\\$' | sed 's/\(.*\)\..*/\1/'`
fi