require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../app_models/stub_disk_file'
require './integration_test'

class ForkerControllerTest < IntegrationTest

  def setup
    super
    Thread.current[:file] = @stub_file = nil
  end
  
  def teardown
    Thread.current[:file] = @stub_file = nil
    super
  end

  test "when fork works new dojo's id is returned" do
    id = checked_save_id

    get 'dojo/start_json', {
      :format => :json,            
      :id => id
    }
    avatar_name = json['avatar_name']    
    assert_not_nil avatar_name
    
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
    
    get "forker/fork", {
      :format => :json,      
      :id => id,
      :avatar => avatar_name,
      :tag => 1
    }
    assert_not_nil json, "assert_not_nil json"
    assert_equal true, json['forked'], json.inspect
    assert_not_nil json['id'], json.inspect    
    assert_equal 10, json['id'].length
    assert_not_equal id, json['id']
    assert Kata.exists?(root_dir, json['id'])    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "if id is bad then fork fails and reason is given as id" do
    get "forker/fork", {
      :format => :json,      
      :id => 'helloworld',
      :avatar => 'hippo',
      :tag => 1
    }
    assert_not_nil json, "assert_not_nil json"
    assert_equal false, json['forked'], json.inspect
    assert_equal 'id', json['reason'], json.inspect 
    assert_nil json['id'], "json['id']==nil"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if language folder no longer exists the fork fails and reason is given as language" do
    Thread.current[:file] = @stub_file = StubDiskFile.new  
    id = '1234512345'
    dead_language = 'xxxxx'
    kata = Kata.new(root_dir, id)
    @stub_file.read=({
      :dir => kata.dir,
      :filename => 'manifest.rb',
      :content => {
        :language => dead_language
      }.inspect
    })

    get "forker/fork", {
      :format => :json,      
      :id => id,
      :avatar => 'hippo',
      :tag => 1
    }
    
    assert_not_nil json, "assert_not_nil json"
    assert_equal false, json['forked'], json.inspect
    assert_equal 'language', json['reason'], json.inspect
    assert_equal dead_language, json['language'], json.inspect
    assert_nil json['id'], "json['id']==nil"    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if avatar not started the fork fails and reason is given as avatar" do
    Thread.current[:file] = @stub_file = StubDiskFile.new  
    id = '1234512345'
    language_name = 'Ruby-installed-and-working'
    kata = Kata.new(root_dir, id)
    @stub_file.read=({
      :dir => kata.dir,
      :filename => 'manifest.rb',
      :content => {
        :language => language_name
      }.inspect
    })
    language = Language.new(root_dir, language_name)
    @stub_file.read=({
      :dir => language.dir,
      :filename => 'instructions',
      :content => "dummy"
    })    

    get "forker/fork", {
      :format => :json,      
      :id => id,
      :avatar => 'hippo',
      :tag => 1
    }
    
    assert_not_nil json, "assert_not_nil json"
    assert_equal false, json['forked'], json.inspect
    assert_equal 'avatar', json['reason'], json.inspect   
    assert_nil json['id'], "json['id']==nil"
  end
  
end

