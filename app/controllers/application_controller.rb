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
    if ENV['CYBERDOJO_TEST_ROOT_DIR']
      path += 'test/cyberdojo/'
    end
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

  def bind(pathed_filename)
    filename = Rails.root.to_s + pathed_filename
    ERB.new(File.read(filename)).result(binding)
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

  #before_filter :set_locale
  def set_locale
    # i18n work is not currently live
    if params[:locale].present?
      session[:locale] = params[:locale]
    end
    original_locale = I18n.locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
  end

end
