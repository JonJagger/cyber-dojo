gmcs -t:library Source.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:Source.dll -r:nunit.framework.dll SourceTest.cs
  if [ $? -eq 0 ]; then
    ./nunit-console.exe SourceTest.dll
  fi
fi

