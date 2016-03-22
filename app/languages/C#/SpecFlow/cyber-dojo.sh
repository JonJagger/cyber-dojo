#!/bin/bash

#build project file
CSPROJ=RunTests.csproj

echo "<Project xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">" > $CSPROJ
echo "  <ItemGroup>" >> $CSPROJ

shopt -s nullglob

for f in *.feature
do
  echo "    <None Include=\"$f\">" >> $CSPROJ
  echo "      <Generator>SpecFlowSingleFileGenerator</Generator>" >> $CSPROJ
  echo "      <LastGenOutput>$f.cs</LastGenOutput>" >> $CSPROJ
  echo "    </None>" >> $CSPROJ
done

echo "  </ItemGroup>" >> $CSPROJ
echo "  <ItemGroup>" >> $CSPROJ
echo "    <None Include=\"RunTests.dll.config\" />" >> $CSPROJ
echo "  </ItemGroup>" >> $CSPROJ
echo "</Project>" >> $CSPROJ

#generate 'code behind'
mono /specflow/specflow.exe generateall RunTests.csproj

dmcs -t:library -r:/usr/lib/mono/SpecFlow/TechTalk.SpecFlow.dll -r:/usr/lib/cli/nunit.framework-2.6/nunit.framework.dll -out:RunTests.dll *.cs
if [ $? -eq 0 ]; then
  nunit-console -nologo RunTests.dll
fi
