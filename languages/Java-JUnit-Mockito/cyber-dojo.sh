rm -f *.class
javac -cp .:`ls *.jar | tr '\n' ':'`  *.java   
if [ $? -eq 0 ]; then
  java -cp .:`ls *.jar | tr '\n' ':'` org.junit.runner.JUnitCore `ls -1 *Test*.class | grep -v '\\$' | sed 's/\(.*\)\..*/\1/'`
fi