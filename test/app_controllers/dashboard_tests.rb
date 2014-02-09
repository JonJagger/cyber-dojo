require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DashboardControllerTest < IntegrationTest

  test "show no avatars" do
    id = checked_save_id
    get "/dashboard/show", { :id => id }
    assert_response :success    
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "show avatars but no traffic-lights" do
    id = checked_save_id
    (1..4).each do |n|
      
      get 'dojo/start_json', {
        :id => id
      }
      avatar_name = json['avatar_name']    
      
      get '/kata/edit', {
        :id => id,
        :avatar => avatar_name
      }
      assert_response :success    
    end
    get "dashboard/show", { :id => id }
    assert_response :success    
  end  
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "show avatars with some traffic lights" do
    id = checked_save_id
    (1..3).each do |n|

      get 'dojo/start_json', {
        :id => id
      }
      avatar_name = json['avatar_name']    

      get '/kata/edit', {
        :id => id,
        :avatar => avatar_name
      }
      assert_response :success

      (1..2).each do |m|
        post 'kata/run_tests', {
          :id => id,
          :avatar => avatar_name,
          :file_content => {
            'cyber-dojo.sh' => ""
          },
          :file_hashes_incoming => {
            'cyber-dojo.sh' => 234234
          },
          :file_hashes_outgoing => {
            'cyber-dojo.sh' => -4545645678
          }          
        }
      end
    end
    get "dashboard/show", { :id => id }
    assert_response :success        
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "show dashboard and open a diff-dialog" do
    id = checked_save_id

    get 'dojo/start_json', {
      :id => id
    }
    avatar_name = json['avatar_name']    

    get '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    assert_response :success

    (1..3).each do |m|
      post 'kata/run_tests', {
        :id => id,
        :avatar => avatar_name,
        :file_content => {
          'cyber-dojo.sh' => ""
        },
        :file_hashes_incoming => {
          'cyber-dojo.sh' => 234234
        },
        :file_hashes_outgoing => {
          'cyber-dojo.sh' => -4545645678
        }          
      }
    end
    get "dashboard/show", {
      :id => id,
      :avatar_name => avatar_name,
      :was_tag => 1,
      :now_tag => 2
    }
    assert_response :success            
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "download zip of empty dojo" do
    id = checked_save_id
    post 'dashboard/download', {
      :id => id
    }
    assert_response :success
    root = Rails.root.to_s + '/test/cyberdojo' 
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"        
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "download zip of non-empty dojo" do
    id = checked_save_id
    
    get 'dojo/start_json', {
      :id => id
    }
    avatar_name = json['avatar_name']    

    get '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    assert_response :success

    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => ""        
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
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

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "help_dialog" do
    id = checked_save_id
    get "/dashboard/help_dialog"
    assert_response :success    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "heartbeat" do
    id = checked_save_id
    
    get 'dojo/start_json', {
      :id => id
    }
    avatar_name = json['avatar_name']
    
    get '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    assert_response :success        
    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => ""        
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }      
    }
    get 'dashboard/heartbeat', {
      :id => id
    }
  end  

end

