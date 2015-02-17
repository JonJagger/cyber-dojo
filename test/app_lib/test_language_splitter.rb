#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class LanguagesDisplayNamesSplitter

  def initialize(display_names)
    @display_names = display_names
  end
  
  def languages_names
    @languages_names ||= split(0)
  end
  
  def tests_names
    @tests_names ||= split(1)
  end
  
  def tests_indexes
    languages_names.map { |name| indexes(name) }
  end
  
private

  def split(n)
    @display_names.map{|name| name.split(',')[n].strip }.sort.uniq
  end

  def indexes(language_name)
    result = [ ]
    @display_names.each { |name|
      if name.start_with?(language_name + ',')
        test_name = name.split(',')[1].strip
        result << tests_names.index(test_name)
      end
    }
    result.shuffle
  end
  
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - -

class LanguageSplitterTests < AppLibTestBase

  test 'display_names is split on comma into [languages_names,tests_names]' do
    languages_display_names = [
      'C++, GoogleTest',  
      'C++, assert',      
      'C, assert',        # <----- selected
      'C, Unity',
      'C, Igloo',
      'Go, testing'
    ]
    
    split = LanguagesDisplayNamesSplitter.new(languages_display_names)
    
    assert_equal [
      'C',   # <----- selected
      'C++',
      'Go'
    ], split.languages_names

    assert_equal [
      'GoogleTest',  # 0
      'Igloo',       # 1
      'Unity',       # 2
      'assert',      # 3
      'testing'      # 4
    ], split.tests_names

    # Need to know which tests names to display and initially select
    # I could make the indexes *not* sorted and the
    # first entry in each array is the initial selection
    
    indexes =   
    [
      [ # C
        3,  # assert  (C, assert)     <---- selected
        1,  # Igloo   (C, Igloo)
        2,  # Unity   (C, Unity)
      ],
      [ # C++
        3,  # assert      (C++, assert)         <---- selected
        0,  # GoogleTest  (C++, GoogleTest)     
      ],
      [ # Go
        4,  # testing     (Go, testing)         <---- selected
      ]
    ]
      
    actual = split.tests_indexes
    assert_equal indexes.length, actual.length
    
    indexes.each_with_index {|array,at|
      assert_equal array.sort, actual[at].sort
    }
    
    selected_index = languages_display_names.index('C, assert')
    assert_equal 2, selected_index
    
    # need to make initial_language_index == 0       (C)
    # need to make split.tests_indexes[0][0] === 3   (assert)
    
  end

end
