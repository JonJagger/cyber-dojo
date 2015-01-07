
require 'json'

def require_relative_in(dir,filenames)
  filenames.each do |filename|
    require_relative dir + '/' + filename
  end
end

# these dependencies have to be loaded in the correct order
# as some of them depend on loading previous ones

require_relative_in('lib', %w{
  Externals
  Docker
  TestRunner
    HostTestRunner
    DockerTestRunner
    DummyTestRunner
  Git
  Disk Dir
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
  Chooser Cleaner FileDeltaMaker
  GitDiff GitDiffBuilder GitDiffParser LineSplitter
  MakefileFilter OutputParser TdGapper

})

require_relative_in('app/models', %w{
  Dojo
  Language Languages
  Exercise Exercises
  Avatar Avatars
  FinishedKatas
  Kata Katas
  Light Sandbox Tag
})
