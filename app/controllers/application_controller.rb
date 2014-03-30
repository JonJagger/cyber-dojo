require File.dirname(__FILE__) + '/../../config/environment.rb'

require 'LinuxPaas'
require 'DockerPaas'
require 'OsDisk'
require 'Git'
require 'Runner'
require 'make_time_helper'
require 'Folders'

class ApplicationController < ActionController::Base
  before_filter :set_locale

  protect_from_forgery

  include MakeTimeHelper

  def id
    # lib/Folders:: not refactored for Docker yet...
    Folders::id_complete(root_path, params[:id]) || ""
  end

  def paas
    ENV['CYBERDOJO_DOCKER'] ? docker_paas : linux_paas
  end

  def linux_paas
    # allow controller_tests to tunnel through rails stack
    thread = Thread.current
    @disk   ||= thread[:disk]   || OsDisk.new
    @git    ||= thread[:git]    || Git.new
    @runner ||= thread[:runner] || Runner.new
    @paas   ||= LinuxPaas.new(@disk, @git, @runner)
  end

  def docker_paas
    thread = Thread.current
    @disk   ||= thread[:disk]   || OsDisk.new
    @paas   ||= DockerPaas.new(@disk)
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
