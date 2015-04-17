
%w{
  DiskFake
  DirFake
  GitSpy
  StubTestRunner
  UniversalStubTestRunner  
}.each {|sourcefile| require_relative './' + sourcefile }
