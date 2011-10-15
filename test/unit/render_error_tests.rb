require File.dirname(__FILE__) + '/../test_helper'
require 'Utils'

# > ruby test/functional/render_error_tests.rb

class RenderErrorTests < ActionController::TestCase

  def setup
    @controller = DojoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_render_error(n, expected)
    html = post :render_error, { :n => n }
    fail = html.body.to_s =~ /Exception caught/
    actual = fail == nil
    assert_equal expected, actual, n.to_s
  end
  
  def test_render_errors_404_422_500
    test_render_error(404, true)
    test_render_error(422, true)
    test_render_error(500, true)
    test_render_error(400, false)
  end
    
end
