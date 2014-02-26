require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../app_models/spy_disk'
require File.dirname(__FILE__) + '/../app_models/stub_git'
require './integration_test'

class ForkerControllerTest < IntegrationTest

  def teardown
    # without these, when #./run_all.sh executes
    # Thread.current settings from these tests can linger
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if id is bad then fork fails and reason is given as id" do
    Thread.current[:disk] = disk = SpyDisk.new
    Thread.current[:git] = git = StubGit.new
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
    assert_equal({ }, git.log)
    disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if language folder no longer exists the fork fails and reason is given as language" do
    Thread.current[:disk] = disk = SpyDisk.new
    Thread.current[:git] = git = StubGit.new
    dojo = Dojo.new(root_path)
    language = dojo.language('xxxx')
    id = '1234512345'
    kata = dojo[id]
    kata.dir.spy_read('manifest.rb', { :language => language.name }.inspect)
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
    assert_equal({ }, git.log)
    disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if avatar not started the fork fails and reason is given as avatar" do
    Thread.current[:disk] = disk = SpyDisk.new
    Thread.current[:git] = git = StubGit.new
    dojo = Dojo.new(root_path)
    id = '1234512345'
    kata = dojo[id]
    language = dojo.language('Ruby-installed-and-working')
    kata.dir.spy_read('manifest.rb', { :language => language.name }.inspect)
    language.dir.make
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
    assert_equal({ }, git.log)
    disk.teardown
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
    Thread.current[:disk] = disk = SpyDisk.new
    Thread.current[:git] = git = StubGit.new
    dojo = Dojo.new(root_path)
    language_name = 'Ruby-installed-and-working'
    id = '1234512345'
    kata = dojo[id]
    kata.dir.spy_read('manifest.rb', { :language => language_name }.inspect)
    language = dojo.language(language_name)
    language.dir.make
    avatar_name = 'hippo'
    avatar = kata[avatar_name]
    avatar.dir.spy_read('increments.rb', [{
        "colour" => "red",
        "time" => [2014, 2, 15, 8, 54, 6],
        "number" => 1
      }].inspect)
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
    assert_equal({ }, git.log)
    disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when id,language,avatar,tag all ok fork works new dojo's id is returned" do
    Thread.current[:disk] = disk = SpyDisk.new
    Thread.current[:git] = git = StubGit.new
    dojo = Dojo.new(root_path)
    language_name = 'Ruby-installed-and-working'
    id = '1234512345'
    kata = dojo[id]
    kata.dir.spy_read('manifest.rb', { :language => language_name }.inspect)
    language = dojo.language(language_name)
    language.dir.spy_read('manifest.json', JSON.unparse(
      {
        'unit_test_framework' => 'fake'
      }))
    avatar_name = 'hippo'
    avatar = kata[avatar_name]
    avatar.dir.spy_read('increments.rb', [
      {
        "colour" => "red",
        "time" => [2014, 2, 15, 8, 54, 6],
        "number" => 1
      },
      {
        "colour" => "green",
        "time" => [2014, 2, 15, 8, 54, 34],
        "number" => 2
      },
      ].inspect)
    get "forker/fork", {
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :tag => 2
    }

    assert_not_nil json, "assert_not_nil json"
    assert_equal true, json['forked'], json.inspect
    assert_not_nil json['id'], json.inspect
    assert_equal 10, json['id'].length
    assert_not_equal id, json['id']
    assert dojo[json['id']].exists?
    # need to be able to properly stub in StubGit so I can return manifest
    # and this assert new dojo has same settings as one forked from
    assert_equal({avatar.path => [ ["show", "2:manifest.rb"]]}, git.log)
    disk.teardown
  end

end
