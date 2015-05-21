
%w{
  DiskStub
  DiskFake
  DirFake
  GitSpy
  StubTestRunner
  DummyTestRunner
  OneSelfDummy
}.each {|sourcefile| require_relative './' + sourcefile }
