
%w{
  BashStub
  DiskStub
  DiskFake
  DirFake
  GitSpy
  RunnerStub
  RunnerStubTrue
}.each {|sourcefile| require_relative './' + sourcefile }
