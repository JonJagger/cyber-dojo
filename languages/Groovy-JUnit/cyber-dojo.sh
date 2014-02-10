rm -f *.class
groovyc *.groovy
if [ $? -eq 0 ]; then
  java -cp .:$(ls *.jar | xargs | sed -e 's/ /:/g') org.junit.runner.JUnitCore `ls -1 *Test*.class | sed 's/\(.*\)\..*/\1/'`
fi