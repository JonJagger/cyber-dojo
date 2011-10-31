javac RomanNumerals.java
if [ $? -eq 0 ]; then
  javac -cp .:./junit-4.7.jar RomanNumeralsTest.java 
  if [ $? -eq 0 ]; then
    java -cp .:./junit-4.7.jar org.junit.runner.JUnitCore RomanNumeralsTest
  fi
fi

