require File.dirname(__FILE__) + '/../test_helper'
require 'Folders'

class FoldersTests < ActionController::TestCase

  test "test languages folder contains C#" do
    folders = Folders.in(root_dir + '/languages')
    assert_equal 1, folders.count('C#') 
  end    

  test "test languages folder doesn't contain . or .." do
    folders = Folders.in(root_dir + '/languages')
    assert_equal 0, folders.count('.')
    assert_equal 0, folders.count('..')
  end    

end

