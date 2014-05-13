
class ExceptionController < ActionController::Base

  def render_error
    render 'error/sorry'
  end

end