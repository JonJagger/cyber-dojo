fsharpc  -r:/usr/lib/cli/FSharp.Core-4.3/FSharp.Core.dll \
         -r:/usr/lib/mono/4.0/mscorlib.dll \
         --noframework \
         -o run-tests.exe *.fs
if [ $? -eq 0 ]; then
  run-tests.exe
fi
