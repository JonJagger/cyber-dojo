gmcs -t:library BowlingGame.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:BowlingGame.dll -r:nunit.framework.dll BowlingGameTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo BowlingGameTest.dll
  fi
fi

