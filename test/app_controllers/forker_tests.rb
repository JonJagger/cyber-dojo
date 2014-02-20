require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../app_models/stub_disk'
require './integration_test'

class ForkerControllerTest < IntegrationTest

  def setup
    super
    Thread.current[:disk] = @disk = nil
  end
  
  def teardown
    Thread.current[:disk] = @disk = nil
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
    assert @dojo[json['id']].exists?
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
    Thread.current[:disk] = @disk = StubDisk.new  
    id = '1234512345'
    language = @dojo.language('xxxx')
    kata = @dojo[id]
    @disk[kata.dir, 'manifest.rb'] = { :language => language.name }.inspect
    get "forker/fork", {
      :format => :json,      
      :id => id,
      :avatar => 'hippo',
      :tag => 1
    }    
    assert_not_nil json, "assert_not_nil json"
    assert_equal false, json['forked'], json.inspect
    assert_equal 'language', json['reason'], json.inspect
    assert_equal language.name, json['language'], json.inspect
    assert_nil json['id'], "json['id']==nil"    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if avatar not started the fork fails and reason is given as avatar" do
    Thread.current[:disk] = @disk = StubDisk.new  
    id = '1234512345'
    language = @dojo.language('Ruby-installed-and-working')
    kata = @dojo[id]
    @disk[kata.dir, 'manifest.rb'] = { :language => language.name }.inspect
    @disk[language.dir, 'instructions'] = 'dummy'
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
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if tag is bad fork fails and reason is given as tag" do
    bad_tag_test('xx')
    bad_tag_test('-14')
    bad_tag_test('-1')
    bad_tag_test('0')
    bad_tag_test('2')
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_tag_test(bad_tag)
    Thread.current[:disk] = @disk = StubDisk.new  
    id = '1234512345'
    language_name = 'Ruby-installed-and-working'
    kata = @dojo[id]
    @disk[kata.dir, 'manifest.rb'] = { :language => language_name }.inspect
    language = @dojo.language(language_name)
    @disk[language.dir, 'instructions'] = 'dummy'
    avatar_name = 'hippo'
    avatar = kata[avatar_name]
    @disk[avatar.dir, 'increments.rb'] = [{
        "colour" => "red",
        "time" => [2014, 2, 15, 8, 54, 6],
        "number" => 1
      }].inspect    
    get "forker/fork", {
      :format => :json,      
      :id => id,
      :avatar => 'hippo',
      :tag => bad_tag
    }    
    assert_not_nil json, "assert_not_nil json"
    assert_equal false, json['forked'], json.inspect
    assert_equal 'tag', json['reason'], json.inspect   
    assert_nil json['id'], "json['id']==nil"    
  end
  
end

