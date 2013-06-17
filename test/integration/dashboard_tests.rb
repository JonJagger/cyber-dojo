require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DashboardControllerTest < IntegrationTest

  test "show no avatars" do
    id = checked_save_id
    get "/dashboard/show", { :id => id }
    assert_response :success    
  end
    
  test "show avatars but no traffic-lights" do
    id = checked_save_id
    (1..4).each do |n|
      get '/kata/edit', {
        :id => id,
        :avatar => Avatar.names[n]
      }
      assert_response :success    
    end
    get "dashboard/show", { :id => id }
    assert_response :success    
  end  
  
  test "show avatars with some traffic lights" do
    id = checked_save_id
    (1..3).each do |n|
      get '/kata/edit', {
        :id => id,
        :avatar => Avatar.names[n]
      }
      assert_response :success

      (1..2).each do |m|
        post 'kata/run_tests', {
          :id => id,
          :avatar => Avatar.names[n],
          :file_content => {
            quoted('cyber-dojo.sh') => ""
          }
        }
      end
    end
    get "dashboard/show", { :id => id }
    assert_response :success        
  end

  test "download zip of dojo" do
    id = checked_save_id
    avatar_name = Avatar.names[0]
    get '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    assert_response :success

    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""        
      }
    }
    post 'dashboard/download', {
      :id => id
    }
    assert_response :success
    root = Rails.root.to_s + '/test/cyberdojo' 
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"    
  end

  test "heartbeat" do
    id = checked_save_id
    avatar_name = Avatar.names[0]
    get '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    assert_response :success        
    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""        
      }
    }
    post 'dashboard/heartbeat', {
      :id => id
    }
  end
  
end

