require File.dirname(__FILE__) + '/../../config/environment.rb'

require 'Disk'
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

  def dojo
    Thread.current[:disk] ||= Disk.new
    Dojo.new(root_path)
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

  def bind(filename)
    filename = Rails.root.to_s + filename
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
    Rails.root.to_s + (ENV['CYBERDOJO_TEST_ROOT_DIR'] ? '/test/cyberdojo' : '')
  end

end
