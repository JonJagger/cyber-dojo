
%w{
  DiskStub
  DiskFake
  DirFake
  GitSpy
  TestRunnerStub
  TestRunnerDummy
  OneSelfDummy
}.each {|sourcefile| require_relative './' + sourcefile }
