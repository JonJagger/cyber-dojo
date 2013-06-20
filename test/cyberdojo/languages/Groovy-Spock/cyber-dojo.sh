groovyc *.groovy

if [ $? -eq 0 ]; then
  java -cp ./groovy-all-2.0.5.jar:./junit-dep-4.10.jar:./hamcrest-core-1.3.jar:./spock-core-0.7-groovy-2.0.jar:. org.junit.runner.JUnitCore `ls -1 *Spec*.class | sed 's/\(.*\)\..*/\1/'`
fi