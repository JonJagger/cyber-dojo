
class ExceptionController < ActionController::Base
  
  def render_error
    @exception = env["action_dispatch.exception"]
    @status_code = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
    if @status_code == 500
      render "error/500"
    else
      render "error/404"
    end    
  end

end