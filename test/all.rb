
require 'json'

def require_relative_in(dir,filenames)
  filenames.each do |filename|
    pathed = '../' + dir + '/' + filename
    require_relative pathed
  end
end

require_relative_in('lib', %w{
  Externals
  Docker
  TestRunner
    HostTestRunner
    DockerTestRunner
    DummyTestRunner
  Git
  Disk DiskFake
  Dir DirFake
  TimeNow UniqueId
})

require_relative_in('app/helpers', %w{
  avatar_image_helper
  logo_image_helper
  parity_helper
  pie_chart_helper
  traffic_light_helper
})

require_relative_in('app/lib', %w{
  Approval Chooser Cleaner FileDeltaMaker
  GitDiff GitDiffBuilder GitDiffParser LineSplitter
  MakefileFilter OutputParser TdGapper

})

require_relative_in('app/models', %w{
  Dojo
  Language Languages
  Exercise Exercises
  Avatar Avatars
  Kata Katas
  Light Sandbox Tag
})

require_relative_in('test/lib', %w{
  DummyGit SpyGit StubTestRunner
})
