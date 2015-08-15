
%w{
  BashStub
  DiskStub
  DiskFake
  DirFake
  GitSpy
  RunnerStub
  RunnerStubTrue
  RunnerDummy
}.each {|sourcefile| require_relative './' + sourcefile }
