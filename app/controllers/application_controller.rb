
def rooted(filename)
  root = File.absolute_path(File.dirname(__FILE__) + '/../../')
  root + '/' + filename
end

load rooted('all.rb')

class ApplicationController < ActionController::Base

  protect_from_forgery

  def initialize
    super
    thread[:disk  ] ||= Disk.new
    thread[:git   ] ||= Git.new
    thread[:runner] ||= DockerTestRunner.new if Docker.installed?
    thread[:runner] ||= HostTestRunner.new unless ENV['CYBERDOJO_USE_HOST'].nil?
    thread[:runner] ||= DummyTestRunner.new
    thread[:exercises_path] ||= root_path + '/exercises/'
    thread[:languages_path] ||= root_path + '/languages/'
    thread[:katas_path]     ||= root_path + '/katas/'
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
    params['was_tag']
  end

  def now_tag
    params['now_tag']
  end

private

  include Externals

  def root_path
    Rails.root.to_s
  end

end
