
fsharpc --nologo \
        --target:library \
        -r:/Packages/NUnit.Runners/tools/nunit.framework.dll \
        -o RunTests.dll *.fs

if [ $? -eq 0 ]; then
  mono /Packages/NUnit.Runners/tools/nunit-console.exe -nologo ./RunTests.dll
fi
