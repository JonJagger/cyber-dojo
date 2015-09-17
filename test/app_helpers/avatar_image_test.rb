#!/bin/bash ../test_wrapper.sh

require_relative 'AppHelpersTestBase'

class AvatarImageTests < AppHelpersTestBase

  include AvatarImageHelper

  test 'E30BAA',
  'avatar_image html' do
    html = avatar_image(name='hippo', size=42, title='wibble')
    assert html.start_with?('<img '), '<img : ' + html
    assert html.match("height='#{size}'"), 'height: ' + html
    assert html.match("width='#{size}'"), 'width: ' + html
    assert html.match("src='/images/avatars/#{name}.jpg'"), 'src: ' + html
    assert html.match("title='wibble'"), 'title: ' + html
    assert html.match("class='avatar-image'"), 'class: ' + html
  end

end
