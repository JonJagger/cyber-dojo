gmcs -t:library RecentlyUsedList.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:RecentlyUsedList.dll -r:nunit.framework.dll RecentlyUsedListTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo RecentlyUsedListTest.dll
  fi
fi

