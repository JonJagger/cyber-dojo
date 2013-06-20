groovyc *.groovy

if [ $? -eq 0 ]; then
  java -cp ./groovy-all-2.1.5.jar:./junit-4.11.jar:./hamcrest-core-1.3.jar:. org.junit.runner.JUnitCore `ls -1 *Test*.class | sed 's/\(.*\)\..*/\1/'`
fi