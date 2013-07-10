rm *.class
javac -cp .:`ls *.jar | tr '\n' ':'`  *.java   
if [ $? -eq 0 ]; then
  java -cp .:`ls *.jar | tr '\n' ':'` org.junit.runner.JUnitCore RunCukesTest
fi


