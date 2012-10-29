require File.dirname(__FILE__) + '/../../config/environment.rb'

class ApplicationController < ActionController::Base
  protect_from_forgery

  def root_dir
    params[:root_dir] || Rails.root.to_s
  end
  
  def id
    p = params[:id]
    p != nil ? p.upcase : p
  end
    
  def browser
    request.env['HTTP_USER_AGENT']
  end

end
