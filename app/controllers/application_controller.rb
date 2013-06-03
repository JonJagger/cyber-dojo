require File.dirname(__FILE__) + '/../../config/environment.rb'

require 'make_time_helper'
require 'Folders'
require 'Uuid'

class ApplicationController < ActionController::Base
  before_filter :set_locale

  protect_from_forgery

  include MakeTimeHelper  

  def root_dir
    Rails.root.to_s + (ENV['CYBERDOJO_TEST_ROOT_DIR'] ? '/test/cyberdojo' : '')
  end
  
  def id
    Folders::id_complete(root_dir, params[:id]) || ""
  end
    
  def browser
    request.env['HTTP_USER_AGENT']
  end
  
  def gather_info    
    language = Language.new(root_dir, params['language'])    
    
    { :created => make_time(Time.now),
      :id => Uuid.new.to_s,
      :browser => browser,
      :language => language.name,
      :exercise => params['exercise'],
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end

  def bind(filename)
    filename = Rails.root.to_s + filename
    ERB.new(File.read(filename)).result(binding)
  end  

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    logger.debug("#{I18n.locale} = #{session[:locale]} || #{I18n.default_locale}")
  end

end



