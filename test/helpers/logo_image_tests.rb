require File.dirname(__FILE__) + '/../test_helper'
require 'logo_image_helper'

class LogoImageTests < ActionView::TestCase

  include LogoImageHelper

  test "logo_image html" do
    html = logo_image(size=42, title='wibble')
    assert html.start_with?('<img '), '<img : ' + html
    assert html.match('alt="cyber-dojo yin-yang logo"'), 'alt: ' + html
    assert html.match("height=\"#{size}\""), 'height: ' + html
    assert html.match("width=\"#{size}\""), 'width: ' + html
    assert html.match('src="/images/avatars/cyber-dojo.png'), 'src: ' + html
    assert html.match('title="wibble"'), 'title: ' + html
  end

end


