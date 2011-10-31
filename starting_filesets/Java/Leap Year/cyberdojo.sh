javac LeapYear.java
if [ $? -eq 0 ]; then
  javac -cp .:./junit-4.7.jar LeapYearTest.java 
  if [ $? -eq 0 ]; then
    java -cp .:./junit-4.7.jar org.junit.runner.JUnitCore LeapYearTest
  fi
fi

