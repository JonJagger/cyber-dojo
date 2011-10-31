gmcs -t:library LeapYear.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:LeapYear.dll -r:nunit.framework.dll LeapYearTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo LeapYearTest.dll
  fi
fi

