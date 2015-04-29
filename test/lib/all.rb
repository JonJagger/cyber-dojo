
%w{
  DiskFake
  DirFake
  GitSpy
  StubTestRunner
  DummyTestRunner  
}.each {|sourcefile| require_relative './' + sourcefile }
