gmcs -t:library Untitled.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:Untitled.dll -r:nunit.framework.dll UntitledTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo UntitledTest.dll
  fi
fi

