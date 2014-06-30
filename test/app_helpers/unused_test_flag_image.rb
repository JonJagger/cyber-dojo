#!/usr/bin/env ruby

require_relative '../test_helper'
require 'flag_image_helper'

class FlagImageTests < ActionView::TestCase

  include FlagImageHelper

  test "flag_image html" do
    html = flag_image(name='French')
    assert html.start_with?('<img '), '<img : ' + html
    assert html.match("alt=\"#{name} flag\""), 'alt: ' + html
    assert html.match('width="50"'), 'width: ' + html
    assert html.match("src=\"/images/countries/#{name}.png"), 'src: ' + html
    assert html.match("title=\"#{name}\""), 'title: ' + html
  end

end
