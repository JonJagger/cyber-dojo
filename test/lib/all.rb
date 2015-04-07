
%w{
  DiskFake
  DirFake
  GitSpy
  StubTestRunner
}.each {|sourcefile| require_relative './' + sourcefile }
