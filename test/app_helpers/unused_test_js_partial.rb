#!/usr/bin/env ruby

require_relative '../test_helper'
require 'application_helper'

class JsPartialTests < ActionView::TestCase

  include ApplicationHelper

  test "js_partial" do
    expected =
    [
      '\\n<div id=\\"output\\">\\n  ' +
      '<textarea class=\\"file_content\\"\\n            ' +
      'spellcheck=\\"false\\"\\n            ' +
      'data-filename=\\"output\\"\\n            ' +
      'name=\\"file_content[output]\\"\\n            ' +
      'id=\\"file_content_for_output\\"\\n            ' +
      'readonly=\\"readonly\\"\\n            ' +
      'wrap=\\"on\\"><\\/textarea>\\n<\\/div>\\n'
    ].join('')
    actual = js_partial('kata/output')
    assert_equal expected, actual
  end

end
