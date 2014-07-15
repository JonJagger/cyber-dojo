fsharpc -o run-tests.exe *.fs
if [ $? -eq 0 ]; then
  run-tests.exe
fi
