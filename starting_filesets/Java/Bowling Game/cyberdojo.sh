javac BowlingGame.java
if [ $? -eq 0 ]; then
  javac -cp .:./junit-4.7.jar BowlingGameTest.java 
  if [ $? -eq 0 ]; then
    java -cp .:./junit-4.7.jar org.junit.runner.JUnitCore BowlingGameTest
  fi
fi

