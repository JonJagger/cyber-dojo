java -cp js.jar org.mozilla.javascript.tools.jsc.Main untitled.js
if [ $? != 0 ]; 
then 
  exit; 
fi

java -cp js.jar org.mozilla.javascript.tools.jsc.Main untitled_test.js
if [ $? != 0 ]; 
then 
  exit; 
fi

java -cp .:js.jar untitled_test


