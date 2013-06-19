require File.dirname(__FILE__) + '/../test_helper'
require 'logo_image_helper'

class LogoImageTests < ActionController::TestCase

  include LogoImageHelper

=begin
  # fails because logo_image cannot see image_tag method  
  test "x" do
    html = logo_image(size=42, title='wibble')
  end
=end

end


