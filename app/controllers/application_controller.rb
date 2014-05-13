__DIR__ = File.dirname(__FILE__) + '/../../'
require __DIR__ + '/config/environment.rb'
require __DIR__ + '/app/lib/LinuxPaas'
require __DIR__ + '/app/lib/DockerRunner'
require __DIR__ + '/app/lib/HostRunner'
require __DIR__ + '/app/lib/NullRunner'
require __DIR__ + '/lib/Folders'
require __DIR__ + '/lib/Git'
require __DIR__ + '/lib/OsDisk'

class ApplicationController < ActionController::Base

  protect_from_forgery

  include MakeTimeHelper # for derived controllers

  def id
    Folders::id_complete(root_path, params[:id]) || ""
  end

  def paas
    # allow app/controller tests to tunnel through rails stack
    thread = Thread.current
    @disk   ||= thread[:disk]   || OsDisk.new
    @git    ||= thread[:git]    || Git.new
    @runner ||= thread[:runner] || runner
    @paas   ||= LinuxPaas.new(@disk, @git, @runner)
  end

  def dojo
    paas.create_dojo(root_path)
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

  def format
    'json'
  end

  def runner
    return DockerRunner.new if docker?
    return HostRunner.new   if ENV['CYBERDOJO_USE_HOST'] != nil
    return NullRunner.new
  end

  def docker?
    `docker info > /dev/null 2>&1`
    $?.exitstatus === 0
  end

private

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
