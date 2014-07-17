
gdc hiker.d -funittest -o run-tests

if [ $? -eq 0 ]; then
  ./run-tests
fi
