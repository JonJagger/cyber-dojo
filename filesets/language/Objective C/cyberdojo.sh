
gcc -Wall -Werror -fconstant-string-class=NSConstantString -I/usr/include/GNUstep untitled.m -c
if [ $? -eq 0 ]; then 
  gcc -Wall -Werror -fconstant-string-class=NSConstantString -I/usr/include/GNUstep untitled_tests.m -c
  if [ $? -eq 0 ]; then 
    gcc untitled.o untitled_tests.o -lgnustep-base -o untitled
    if [ $? -eq 0 ]; then 
      ./untitled
    fi  
  fi
fi





