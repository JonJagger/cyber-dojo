
class ExceptionController < ActionController::Base

  def render_error
    render 'error/sorry'
  end

  def render_offline
    render 'offline/sorry'
  end

end