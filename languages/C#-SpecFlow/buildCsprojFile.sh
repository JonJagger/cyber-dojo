#!/bin/bash

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
echo "</Project>" >> $CSPROJ