g++ -Wall -Werror *.cpp *.m *.mm -framework Foundation -o untitled
if [ $? -eq 0 ]; then 
	./untitled
fi
 
