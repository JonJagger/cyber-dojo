# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'TdGapper'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '945dc57b815c0ad35dfe0b403fb13b89'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos'
    params[:starting_filesets_root] = RAILS_ROOT + '/' + 'starting_filesets'
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
    params[:browser] = request.env['HTTP_USER_AGENT'] 
  end
  
  def board_config(params)
    configure(params)
    @dojo = Dojo.new(params)
  end
  
  def dojo_name
    params[:dojo_name]
  end
    
end
