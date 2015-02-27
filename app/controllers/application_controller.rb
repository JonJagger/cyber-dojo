
def rooted(filename)
  root = File.absolute_path(File.dirname(__FILE__) + '/../../')
  root + '/' + filename
end

load rooted('all.rb')

class ApplicationController < ActionController::Base

  protect_from_forgery

  def initialize
    super
    set_external(:disk,   Disk.new)
    set_external(:git,    Git.new)
    set_external(:runner, test_runner)
    set_external(:exercises_path, root_path + '/exercises/')
    set_external(:languages_path, root_path + '/languages/')
    set_external(:katas_path,     root_path + '/katas/')
  end

  def dojo
    @dojo ||= Dojo.new
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
    params[:was_tag]
  end

  def now_tag
    params[:now_tag]
  end

private

  include ExternalSetter

  def root_path
    Rails.root.to_s
  end

  def test_runner
    return DockerTestRunner.new if Docker.installed?
    return HostTestRunner.new unless ENV['CYBERDOJO_USE_HOST'].nil?
    return DummyTestRunner.new
  end

end
