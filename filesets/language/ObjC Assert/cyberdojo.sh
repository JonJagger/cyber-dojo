gcc -Wall -Werror -ObjC untitled.m -c
if [ $? -eq 0 ]; then 
  gcc -Wall -Werror -ObjC untitled_tests.m -c
  if [ $? -eq 0 ]; then 
    gcc untitled.o untitled_tests.o -framework Foundation -o untitled
    if [ $? -eq 0 ]; then 
      ./untitled
    fi  
  fi
fi
 
