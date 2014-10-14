root = '../..'

require_relative root + '/config/environment.rb'

require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

class ApplicationController < ActionController::Base

  protect_from_forgery

  def id
    path = root_path
    path += 'test/cyberdojo/' if ENV['CYBERDOJO_TEST_ROOT_DIR']
    Folders::id_complete(path + 'katas/', params[:id]) || ''
  end

  def dojo
    externals = {
      :runner => runner,
      :disk   => disk,
      :git    => git
    }
    Dojo.new(root_path,externals)
  end

  def katas
    dojo.katas
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

  def root_path
    Rails.root.to_s + '/'
  end

private

  def runner
    @runner ||= Thread.current[:runner]
    @runner ||= DockerTestRunner.new if Docker.installed?
    @runner ||= HostTestRunner.new   if !ENV['CYBERDOJO_USE_HOST'].nil?
    @runner ||= DummyTestRunner.new
  end

  def disk
    @disk ||= Thread.current[:disk]
    @disk ||= OsDisk.new
  end

  def git
    @git ||= Thread.current[:git]
    @git ||= Git.new
  end

end
