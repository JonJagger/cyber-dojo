
require 'json'

def require_relative_in(dir,filenames)
  filenames.each do |filename|
    require_relative dir + '/' + filename
  end
end

# these dependencies have to be loaded in the correct order
# as some of them depend on loading previous ones

require_relative_in('lib', %w{
  External
  ExternalDiskDir
  ExternalGit
  ExternalRunner
  ExternalExercisesPath
  ExternalLanguagesPath
  ExternalKatasPath
  ExternalSetter
  Cleaner
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
  tip_helper
})

require_relative_in('app/lib', %w{
  Chooser FileDeltaMaker
  GitDiff GitDiffBuilder GitDiffParser LineSplitter
  ReviewFilePicker
  PrevNextRing
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
