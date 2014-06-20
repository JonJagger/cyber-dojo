__DIR__ = File.dirname(__FILE__) + '/../../'
require __DIR__ + '/config/environment.rb'
require __DIR__ + '/app/lib/Docker'
require __DIR__ + '/app/lib/DockerTestRunner'
require __DIR__ + '/app/lib/DummyTestRunner'
require __DIR__ + '/app/lib/HostTestRunner'
require __DIR__ + '/lib/Folders'
require __DIR__ + '/lib/Git'
require __DIR__ + '/lib/OsDisk'

require 'Externals'

class ApplicationController < ActionController::Base
  include Externals

  protect_from_forgery

  include MakeTimeHelper # for derived controllers

  def id
    Folders::id_complete(root_path + 'katas/', params[:id]) || ""
  end

  def dojo
    set_disk(OsDisk.new)
    set_git(Git.new)
    set_runner(runner)
    Dojo.new(root_path, 'json')
  end

  def bind(pathed_filename)
    filename = Rails.root.to_s + pathed_filename
    ERB.new(File.read(filename)).result(binding)
  end

  def root_path
    # See test/app_controllers/integration_test.rb
    Rails.root.to_s + (ENV['CYBERDOJO_TEST_ROOT_DIR'] ? '/test/cyberdojo/' : '/')
  end

private

  def runner
    return DockerTestRunner.new if Docker.installed?
    # export CYBERDOJO_USE_HOST=true
    return HostTestRunner.new   if ENV['CYBERDOJO_USE_HOST'] != nil
    return DummyTestRunner.new
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
