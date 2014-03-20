require File.dirname(__FILE__) + '/../../config/environment.rb'

require 'LinuxPaas'
require 'Disk'
require 'Git'
require 'Runner'
require 'make_time_helper'
require 'Folders'
require 'Uuid'

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
    @disk = thread[:disk] || Disk.new
    @git = thread[:git] || Git.new
    @runner = thread[:runner] || Runner.new
    @paas ||= LinuxPaas.new(@disk, @git, @runner)
  end

  def dojo
    format = 'json'
    paas.create_dojo(root_path, format)
  end

  def make_manifest(language_name, exercise_name)
    language = dojo.language(language_name)
    {
      :created => make_time(Time.now),
      :id => Uuid.new.to_s,
      :language => language.name,
      :exercise => exercise_name, # used only for display
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
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

end
