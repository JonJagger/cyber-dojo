
%w{
  DiskFake
  DirFake
  GitSpy
  RunnableTestRunner
  StubTestRunner
}.each {|sourcefile| require_relative './' + sourcefile }
