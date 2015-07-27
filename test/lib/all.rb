
%w{
  BashStub
  DiskStub
  DiskFake
  DirFake
  GitSpy
  RunnerStub
  RunnerStubTrue
  RunnerDummy
  OneSelfDummy
}.each {|sourcefile| require_relative './' + sourcefile }
