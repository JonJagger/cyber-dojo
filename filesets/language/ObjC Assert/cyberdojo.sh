gcc -Wall -Werror *.m -framework Foundation -o untitled
if [ $? -eq 0 ]; then 
  ./untitled
fi  
 
