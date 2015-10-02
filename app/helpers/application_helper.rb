
module ApplicationHelper # mix-in

  module_function

  def js_partial(partial)
    escape_javascript(render :partial => partial)
  end

end
