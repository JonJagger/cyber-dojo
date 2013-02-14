javac -cp .:./junit-4.11.jar:./ApprovalTests.012.jar *.java 
if [ $? -eq 0 ]; then
  java -cp .:./junit-4.11.jar:./ApprovalTests.012.jar org.junit.runner.JUnitCore `ls -1 *Test*.class | sed 's/\(.*\)\..*/\1/'`
fi

if [ -f *.received.txt ]; then
    for filename in *.received.txt; do
      echo $filename
      cat $filename
    done
fi
