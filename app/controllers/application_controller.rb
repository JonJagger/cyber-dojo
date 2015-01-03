
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
  Disk Dir
  Git
  TimeNow UniqueId
}

require_dependencies %w{
  Chooser Cleaner FileDeltaMaker
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
    thread[:disk  ] ||= Disk.new
    thread[:git   ] ||= Git.new
    thread[:runner] ||= DockerTestRunner.new if Docker.installed?
    thread[:runner] ||= HostTestRunner.new unless ENV['CYBERDOJO_USE_HOST'].nil?
    thread[:runner] ||= DummyTestRunner.new
  end

  def dojo
    @dojo ||= Dojo.new(Rails.root.to_s)
  end

  def katas
    dojo.katas
  end

  def id
    @id ||= katas.complete(params[:id])
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

  include Externals

end
