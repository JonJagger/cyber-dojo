#!/usr/bin/env ruby

require_relative './app_lib_test_base'

def split(display_names)  
  part = lambda { |n| display_names.map{|name| name.split(',')[n].strip }.sort.uniq }  
  [part.(0), part.(1)]
end


class LanguageSplitterTests < AppLibTestBase

  test 'display_names is split on comma into [languages_names,tests_names]' do
    languages_display_names = [ 
      'C++, GoogleTest', 
      'C++, assert', 
      'C, assert', 
      'C, Unity', 
      'C, Igloo',
      'Go, testing'
    ]
    
    languages_names,tests_names = split(languages_display_names)
    assert_equal ['C','C++','Go'], languages_names
    assert_equal ['GoogleTest','Igloo','Unity','assert','testing'], tests_names
  end

end
