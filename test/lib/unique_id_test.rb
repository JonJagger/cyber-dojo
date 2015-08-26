#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class UniqueIdTests < LibTestBase

  include UniqueId

  test 'its a string' do
    assert_equal 'String', unique_id.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'its 10 chars long' do
    (0..25).each do
      assert_equal 10, unique_id.length
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'it contains only [0-9 A-E] chars' do
    (0..25).each do |n|
      id = unique_id
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end
    end
  end

end
