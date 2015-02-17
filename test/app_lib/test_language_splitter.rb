#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class LanguagesDisplayNamesSplitter

  def initialize(display_names)
    @display_names = display_names
  end
  
  def languages_names
    split(0)
  end
  
  def tests_names
    split(1)
  end
  
private

  def split(n)
    @display_names.map{|name| name.split(',')[n].strip }.sort.uniq
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
    
    split = LanguagesDisplayNamesSplitter.new(languages_display_names)
    assert_equal ['C','C++','Go'], split.languages_names
    assert_equal ['GoogleTest','Igloo','Unity','assert','testing'], split.tests_names
    
    selected_index = languages_display_names.index('C, assert')
    assert_equal 2, selected_index
    
    #assert_equal [3,0,5], initial_test_indexes
    
  end

end
