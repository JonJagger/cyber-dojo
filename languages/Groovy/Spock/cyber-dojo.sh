rm -f *.class
groovyc -cp /groovy/spock-core-0.7-groovy-2.0.jar *.groovy
if [ $? -eq 0 ]; then
  java -cp .:$(ls /groovy/*.jar | xargs | sed -e 's/ /:/g') org.junit.runner.JUnitCore `ls -1 *Spec*.class | sed 's/\(.*\)\..*/\1/'`
fi
