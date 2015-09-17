#!/bin/bash ../test_wrapper.sh

require_relative 'AppHelpersTestBase'

class LogoImageTests < AppHelpersTestBase

  include LogoImageHelper

  test '27DC8E',
  "logo_image html" do
    html = logo_image(size=42, title='wibble')
    assert html.start_with?('<img '), '<img : ' + html
    assert html.match("alt='cyber-dojo yin-yang logo'"), 'alt: ' + html
    assert html.match("height='42'"), 'height: ' + html
    assert html.match("width='42'"), 'width: ' + html
    assert html.match("src='/images/avatars/cyber-dojo.png'"), 'src: ' + html
    assert html.match("title='wibble'"), 'title: ' + html
  end

  test '118CDC',
  "home_page_logo html" do
    html = home_page_logo
    assert html.start_with?('<img '), '<img: ' + html
    assert html.match("alt='cyber-dojo'"), 'alt: ' + html
    assert html.match("title='cyber-dojo'"), 'title: ' + html
    assert html.match("src='/images/home_page_logo.png'"), 'src: ' + html
  end

end
