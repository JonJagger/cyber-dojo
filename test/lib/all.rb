
%w{
  DiskFake
  DirFake
  GitSpy
  StubTestRunner
  DummyTestRunner  
  UniversalStubTestRunner  
}.each {|sourcefile| require_relative './' + sourcefile }
