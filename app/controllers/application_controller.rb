
def require_dependencies(file_names)
  file_names.each{ |file_name| require_dependency file_name}
end

# these dependencies have to be loaded in the correct order
# as some of them depend on loading previous ones

require_dependencies %w{
  Externals
  Docker
  TestRunner
    DockerTestRunner
    DummyTestRunner
    HostTestRunner
  Disk
    OsDisk OsDir
  Folders Git
  TimeNow UniqueId
}

require_dependencies %w{
  Approval Chooser Cleaner FileDeltaMaker
  GitDiff GitDiffBuilder GitDiffParser LineSplitter
  MakefileFilter OutputParser TdGapper
}

require_dependencies %w{
  Dojo
  Language Languages
  Exercise Exercises
  Avatar Avatars
  Kata Katas
  Light Sandbox Tag
}

class ApplicationController < ActionController::Base

  protect_from_forgery

  def initialize
    super
    disk; git; runner # put externals onto Thread.current
  end

  def dojo
    @dojo ||= Dojo.new(root_path)
  end

  def katas
    dojo.katas
  end

  def id
    @id ||= Folders::id_complete(katas.path, params[:id]) || ''
  end

  def kata
    katas[id]
  end

  def avatars
    kata.avatars
  end

  def avatar_name
	params[:avatar]
  end

  def avatar
    avatars[avatar_name]
  end

  def was_tag
    params['was_tag']
  end

  def now_tag
    params['now_tag']
  end

private

  def root_path
    Rails.root.to_s
  end

  include Externals

end
