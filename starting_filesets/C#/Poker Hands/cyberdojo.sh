gmcs -t:library PokerHands.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:PokerHands.dll -r:nunit.framework.dll PokerHandsTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo PokerHandsTest.dll
  fi
fi

