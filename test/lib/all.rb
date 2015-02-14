
%w{
  DiskFake
  DirFake
  GitSpy
  TestRunnerStub
}.each {|sourcefile| require_relative './' + sourcefile }
