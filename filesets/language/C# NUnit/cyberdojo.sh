
gmcs -t:library -r:nunit.framework.dll -out:RunTests.dll *.cs
if [ $? -eq 0 ]; then
  nunit-console -nologo RunTests.dll
fi
