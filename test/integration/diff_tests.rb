require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DiffControllerTest < IntegrationTest

  test "show tag_0-tag_1 diff with no change to any file" do
    id = checked_save_id
    avatar_name = Avatar.names[0]
    
    post '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    
    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""
      }
    }
    
    get "diff/show", {
      :id => id,
      :avatar => avatar_name,
      :was_tag => 0,
      :now_tag => 1
    }
    assert_response :success
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "show tag_1-tag_1 (no diff) no change in any file" do
    id = checked_save_id
    kata = Kata.new(root_dir, id)    
    avatar_name = Avatar.names[0]
    
    post '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    
    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => Avatar.new(kata, avatar_name).visible_files
    }
    
    get "diff/show", {
      :id => id,
      :avatar => avatar_name,
      :was_tag => 1,
      :now_tag => 1
    }
    assert_response :success
  end

end

