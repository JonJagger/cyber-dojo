fcs -out:RunTests.dll *.fs
if [ $? -eq 0 ]; then
  fsunit-console -nologo RunTests.dll
fi