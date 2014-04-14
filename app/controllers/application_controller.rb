__DIR__ = File.dirname(__FILE__) + '/../../'
require __DIR__ + '/config/environment.rb'
require __DIR__ + '/app/lib/DockerRunner'
require __DIR__ + '/app/lib/LinuxPaas'
require __DIR__ + '/app/lib/RawRunner'
require __DIR__ + '/lib/Folders'
require __DIR__ + '/lib/Git'
require __DIR__ + '/lib/OsDisk'

class ApplicationController < ActionController::Base
  before_filter :set_locale, :set_header_expires

  protect_from_forgery

  include MakeTimeHelper

  def id
    Folders::id_complete(root_path, params[:id]) || ""
  end

  def paas
    # allow controller_tests to tunnel through rails stack
    thread = Thread.current
    @disk   ||= thread[:disk]   || OsDisk.new
    @git    ||= thread[:git]    || Git.new
    @runner ||= thread[:runner] || runner
    @paas   ||= LinuxPaas.new(@disk, @git, @runner)
  end

  def dojo
    paas.create_dojo(root_path, format)
  end

  def bind(pathed_filename)
    filename = Rails.root.to_s + pathed_filename
    ERB.new(File.read(filename)).result(binding)
  end

  def set_locale
    if params[:locale].present?
      session[:locale] = params[:locale]
    end
    original_locale = I18n.locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
  end

  def set_header_expires
    response.headers['Expires"'] = 1.year.from_now.httpdate
  end

  def root_path
    Rails.root.to_s + (ENV['CYBERDOJO_TEST_ROOT_DIR'] ? '/test/cyberdojo/' : '/')
  end

private

  def format
    'json'
  end

  def runner
    docker? ? DockerRunner.new : RawRunner.new
  end

  def docker?
    `docker info > /dev/null 2>&1`
    $?.exitstatus === 0 && ENV['CYBERDOJO_USE_HOST'] === nil
  end

end
