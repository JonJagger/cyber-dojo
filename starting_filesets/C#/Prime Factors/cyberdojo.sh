gmcs -t:library PrimeFactors.cs
if [ $? -eq 0 ]; then
  gmcs -t:library -r:PrimeFactors.dll -r:nunit.framework.dll PrimeFactorsTest.cs
  if [ $? -eq 0 ]; then
    nunit-console -nologo PrimeFactorsTest.dll
  fi
fi

