require File.dirname(__FILE__) + '/../test_helper'

class RenderErrorTests < ActionController::TestCase

  def setup
    @controller = DojoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  test "render errors 404 422 500" do
    check_render_error(404, true)
    check_render_error(422, true)
    check_render_error(500, true)
    check_render_error(400, false)
  end
    
  def check_render_error(n, expected)
    html = post :render_error, { :n => n }
    fail = html.body.to_s =~ /Exception caught/
    actual = fail == nil
    assert_equal expected, actual, n.to_s
  end
  
end
