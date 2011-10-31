gmcs -t:library Yahtzee.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:Yahtzee.dll -r:nunit.framework.dll YahtzeeTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo YahtzeeTest.dll
  fi
fi

