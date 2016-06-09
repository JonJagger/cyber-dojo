NUNIT_PATH=/moq/NUnit.2.6.2/lib
MOQ_PATH=/moq/Moq.4.0.10827/lib/NET40
export MONO_PATH=${NUNIT_PATH}:${MOQ_PATH}

export HOME=/sandbox
dmcs -t:library \
  -r:${NUNIT_PATH}/nunit.framework.dll \
  -r:${MOQ_PATH}/Moq.dll \
  -out:RunTests.dll *.cs

if [ $? -eq 0 ]; then
  NUNIT_RUNNERS_PATH=/moq/NUnit.Runners.2.6.1/tools
  mono ${NUNIT_RUNNERS_PATH}/nunit-console.exe -nologo ./RunTests.dll
fi
