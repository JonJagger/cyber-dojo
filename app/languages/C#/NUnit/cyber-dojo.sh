dmcs -t:library -r:/usr/lib/cli/nunit.framework-2.6/nunit.framework.dll -out:RunTests.dll *.cs
if [ $? -eq 0 ]; then
  nunit-console -nologo RunTests.dll
fi