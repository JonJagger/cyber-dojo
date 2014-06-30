#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative 'integration_test'
require 'SpyDisk'
require 'SpyGit'
require 'StubTestRunner'

class ForkerControllerTest < IntegrationTest

  def thread
    Thread.current
  end

  def setup_dojo
    externals = {
      :disk   => @disk   = thread[:disk  ] = SpyDisk.new,
      :git    => @git    = thread[:git   ] = SpyGit.new,
      :runner => @runner = thread[:runner] = StubTestRunner.new
    }
    @dojo = Dojo.new(root_path,externals)
  end

  def teardown
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
    #TODO: @disk.teardown
    #TODO: @git.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is bad ' +
       'then fork fails ' +
       'and the reason is id' do
    setup_dojo

    get 'forker/fork',
      :format => :json,
      :id => 'bad',
      :avatar => 'hippo',
      :tag => 1

    assert_not_nil json, 'assert_not_nil json'
    assert_equal false, json['forked'], json.inspect
    assert_equal 'id', json['reason'], json.inspect
    assert_nil json['id'], "json['id']==nil"
    assert_equal({ }, @git.log)
    @disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when language folder no longer exists ' +
       'the fork fails ' +
       'and the reason is language' do
    setup_dojo
    language = @dojo.languages['does-not-exist']
    id = '1234512345'
    kata = @dojo.katas[id]
    kata.dir.spy_read('manifest.json', { :language => language.name })

    get 'forker/fork',
      :format => :json,
      :id => id,
      :avatar => 'hippo',
      :tag => 1

    assert_not_nil json, 'assert_not_nil json'
    assert_equal false, json['forked'], json.inspect
    assert_equal 'language', json['reason'], json.inspect
    assert_equal language.name, json['language'], json.inspect
    assert_nil json['id'], "json['id']==nil"
    assert_equal({ }, @git.log)
    @disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when avatar not started ' +
       'the fork fails ' +
       'and the reason is avatar' do
    setup_dojo
    language = @dojo.languages['Ruby-installed-and-working']
    language.dir.make
    language.dir.spy_exists?('manifest.json')

    id = '1234512345'
    kata = @dojo.katas[id]
    kata.dir.spy_read('manifest.json', { :language => language.name })

    get 'forker/fork',
      :format => :json,
      :id => id,
      :avatar => 'hippo',
      :tag => 1

    assert_not_nil json, 'assert_not_nil json'
    assert_equal false, json['forked'], json.inspect
    assert_equal 'avatar', json['reason'], json.inspect
    assert_nil json['id'], "json['id']==nil"
    assert_equal({ }, @git.log)
    @disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when tag is bad ' +
       'the fork fails ' +
       'and the reason is bad tag' do
    bad_tag_test('xx')      # !is_tag
    bad_tag_test('-14')     # tag <= 0
    bad_tag_test('-1')      # tag <= 0
    bad_tag_test('0')       # tag <= 0
    bad_tag_test('2',true)  # tag > avatar.lights.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_tag_test(bad_tag, more_than_number_of_lights = false)
    setup_dojo
    language_name = 'Ruby-installed-and-working'
    language = @dojo.languages[language_name]
    language.dir.make
    language.dir.spy_exists?('manifest.json')

    id = '1234512345'
    kata = @dojo.katas[id]
    kata.dir.make
    kata.dir.spy_read('manifest.json', { :language => language_name })

    avatar_name = 'hippo'
    avatar = kata.avatars[avatar_name]
    avatar.dir.make

    if more_than_number_of_lights
      avatar.dir.spy_read('increments.json',
        JSON.unparse([
          [
            'colour' => 'red',
            'time' => [2014, 2, 15, 8, 54, 6],
            'number' => 1
          ]
        ]))
    end

    get "forker/fork",
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :tag => bad_tag

    assert_not_nil json, "assert_not_nil json"
    assert_equal false, json['forked'], json.inspect + ':' + bad_tag
    assert_equal 'tag', json['reason'], json.inspect + ':' + bad_tag
    assert_nil json['id'], "json['id']==nil : " + bad_tag
    assert_equal({ }, @git.log)

    @disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when language has been renamed but new-name-language exists ' +
       'and id,avatar,tag all ok ' +
       'the fork works ' +
       "and new dojo's id is returned" do
    setup_dojo
    id = '1234512345'
    kata = @dojo.katas[id]

    old_language_name = 'C#'
    new_language_name = 'C#-NUnit'

    kata.dir.spy_read('manifest.json', {
      :language => old_language_name
    })
    language = @dojo.languages[new_language_name]
    language.dir.spy_read('manifest.json', {
      'unit_test_framework' => 'fake'
    })

    avatar_name = 'hippo'
    avatar = kata.avatars[avatar_name]
    avatar.dir.spy_read('increments.json', JSON.unparse([
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      ]))

    manifest = JSON.unparse({
      'Hiker.cs' => 'public class Hiker { }',
      'HikerTest.cs' => 'using NUnit.Framework;'
    })
    tag = 2
    filename = 'manifest.json'
    @git.spy(avatar.dir.path,'show',"#{tag}:#{filename}",manifest)

    get 'forker/fork',
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :tag => tag

    assert_not_nil json, 'assert_not_nil json'
    assert_equal true, json['forked'], json.inspect
    assert_not_nil json['id'], json.inspect
    assert_equal 10, json['id'].length
    assert_not_equal id, json['id']
    assert @dojo.katas[json['id']].exists?

    # TODO: assert new dojo has same settings as one forked from

    assert_equal({avatar.path => [ ['show', '2:manifest.json']]}, @git.log)
    @disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id,language,avatar,tag all ok ' +
       'the fork works ' +
       "and new dojo's id is returned" do
    setup_dojo
    language_name = 'Ruby-installed-and-working'
    id = '1234512345'
    kata = @dojo.katas[id]
    kata.dir.spy_read('manifest.json', { :language => language_name })
    language = @dojo.languages[language_name]
    language.dir.spy_read('manifest.json', {
        'unit_test_framework' => 'fake'
      })
    avatar_name = 'hippo'
    avatar = kata.avatars[avatar_name]
    avatar.dir.spy_read('increments.json', JSON.unparse([
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      },
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      },
      ]))

    manifest = JSON.unparse({
      'Hiker.cs' => 'public class Hiker { }',
      'HikerTest.cs' => 'using NUnit.Framework;'
    })
    tag = 2
    filename = 'manifest.json'
    @git.spy(avatar.dir.path,'show',"#{tag}:#{filename}",manifest)

    get 'forker/fork',
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :tag => tag

    assert_not_nil json, 'assert_not_nil json'
    assert_equal true, json['forked'], json.inspect
    assert_not_nil json['id'], json.inspect
    assert_equal 10, json['id'].length
    assert_not_equal id, json['id']
    assert @dojo.katas[json['id']].exists?

    # TODO: assert new dojo has same settings as one forked from

    assert_equal({avatar.path => [ ['show', '2:manifest.json']]}, @git.log)
    @disk.teardown
  end

end
