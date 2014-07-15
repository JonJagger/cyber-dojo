fsharpc -r:/Packages/FsUnit/Lib/Net40/FsUnit.NUnit.dll  \
        -r:/Packages/NUnit/lib/nunit.framework.dll \
        -o run-tests.exe *.fs
if [ $? -eq 0 ]; then
  run-tests.exe
fi
