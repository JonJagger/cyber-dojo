require File.dirname(__FILE__) + '/../../config/environment.rb'

require 'LinuxPaas'
require 'OsDisk'
require 'Git'
require 'RawRunner'
require 'DockerRunner'
require 'Folders'

class ApplicationController < ActionController::Base
  before_filter :set_locale

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
    @runner ||= thread[:runner] || choose_runner
    @paas   ||= LinuxPaas.new(@disk, @git, @runner)
  end

  def choose_runner
    docker? ? DockerRunner.new : RawRunner.new
  end

  def docker?
    `docker info`
    exit_status = $?.exitstatus
    result = exit_status === 0
    Rails.logger.debug("$?.exitstatus == #{exit_status}")
    result
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

  def root_path
    Rails.root.to_s + (ENV['CYBERDOJO_TEST_ROOT_DIR'] ? '/test/cyberdojo/' : '/')
  end

  def format
    'json'
  end

end
