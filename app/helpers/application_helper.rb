module ApplicationHelper
  def js_partial(partial)
    escape_javascript(render :partial => partial)
  end
end
