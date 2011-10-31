gmcs -t:library RomanNumerals.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:RomanNumerals.dll -r:nunit.framework.dll RomanNumeralsTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo RomanNumeralsTest.dll
  fi
fi

