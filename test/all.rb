
require_relative '../all'

require_relative_in('test/lib', %w{
  DiskFake DirFake
  GitSpy TestRunnerStub
})
