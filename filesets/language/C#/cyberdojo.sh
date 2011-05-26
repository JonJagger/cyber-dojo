gmcs -t:library Untitled.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:Untitled.dll -r:nunit.framework.dll UntitledTest.cs
  if [ $? -eq 0 ]; then
    nunit-console2 -nologo UntitledTest.dll
  fi
fi

