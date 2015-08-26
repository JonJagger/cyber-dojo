#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class LanguagesDisplayNamesSplitterTests < LibTestBase

  test 'display_names is split on comma into [languages_names,tests_names]' do
    
    # At present 
    # o) the languages' display_names combine the name of the 
    #    language *and* the name of the test framework.
    # o) The languages/ folder does *not* have a nested structure. 
    #    It probably should have.
    #
    # It makes sense to mirror the pattern of each language having its
    # own docker image, and sub folders underneath it add their
    # own test framework, and implicitly use their parents folder's
    # docker image to build FROM in their Dockerfile
  
    languages_display_names = [
      'C++, GoogleTest',  
      'C++, assert',      # <----- selected
      'C, assert',        
      'C, Unity',
      'C, Igloo',
      'Go, testing'
    ]
    
    selected_index = languages_display_names.index('C++, assert')
    assert_equal 1, selected_index
    
    languages = LanguagesDisplayNamesSplitter.new(languages_display_names, selected_index)
    
    assert_equal [
      'C',   
      'C++',  # <----- selected_index
      'Go'
    ], languages.names
    
    assert_equal [
      'GoogleTest',  # 0
      'Igloo',       # 1
      'Unity',       # 2
      'assert',      # 3
      'testing'      # 4
    ], languages.tests_names

    # Need to know which tests names to display and initially select
    # Make the indexes *not* sorted and the
    # first entry in each array is the initial selection
    
    indexes =   
    [
      [ # C
        1,  # Igloo   (C, Igloo)
        2,  # Unity   (C, Unity)
        3,  # assert  (C, assert)    
      ],
      [ # C++
        0,  # GoogleTest  (C++, GoogleTest)     
        3,  # assert      (C++, assert)         <---- selected
      ],
      [ # Go
        4,  # testing     (Go, testing)         
      ]
    ]
      
    actual = languages.tests_indexes
    assert_equal indexes.length, actual.length
    
    indexes.each_with_index {|array,at|
      assert_equal array, actual[at].sort
    }
    
    assert_equal 1, languages.selected_index         # C++
    assert_equal 3, languages.tests_indexes[1][0]    # assert
    
  end

end
