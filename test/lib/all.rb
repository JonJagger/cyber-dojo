
%w{
  DiskFake
  DirFake
  GitSpy
  TestRunnerStub
  StubTestRunner
}.each {|sourcefile| require_relative './' + sourcefile }
