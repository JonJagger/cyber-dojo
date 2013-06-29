require File.dirname(__FILE__) + '/../test_helper'
require 'Folders'

class FoldersTests < ActionController::TestCase

  test "test languages folder doesn't contain . or .." do
    folders = Folders::in(root_dir + '/languages')
    assert_equal 0, folders.count('.')
    assert_equal 0, folders.count('..')
  end    

  test "id_complete when id is nil is nil" do
    assert_equal nil, Folders::id_complete(root_dir, nil)  
  end
  
  test "id_complete when id is less than 4 chars in length is unchanged id" do
    id = "123"
    assert_equal id, Folders::id_complete(root_dir, id)
  end
  
  test "id_complete when id is greater than or equal to 10 chars in length is unchanged id" do
    id = "123456789A"
    assert_equal id, Folders::id_complete(root_dir, id)
  end
  
  test "id_complete with no matching id is unchanged id" do
    make_dir(root_dir + '/katas/12/345ABCDE/wolf')
    assert_equal '123AEEE', Folders::id_complete(root_dir, '123AEEE')    
  end
  
  test "id_complete with one matching id is found and returned as id" do
    make_dir(root_dir + '/katas/12/345ABCDE/wolf')
    assert_equal '12345ABCDE', Folders::id_complete(root_dir, '1234')
  end
  
  test "id_complete with two matching ids found is unchanged id" do
    # 12/345... and 12/346... diff is in 5th character
    make_dir(root_dir + '/katas/12/345ABCDE/wolf')
    make_dir(root_dir + '/katas/12/346ABCDE/wolf')
    assert_equal '1234', Folders::id_complete(root_dir, '1234')    
  end
  
  def make_dir(dir)
    `mkdir -p #{dir}`
  end
end

