
%w{
  BashStub
  DiskStub
  DiskFake
  DirFake
  GitSpy
  RunnerStub
  RunnerDummy
  OneSelfDummy
}.each {|sourcefile| require_relative './' + sourcefile }
