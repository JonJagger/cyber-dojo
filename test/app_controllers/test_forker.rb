#!/usr/bin/env ruby

require_relative 'controller_test_base'

class ForkerControllerTest < ControllerTestBase

  test 'when id is invalid ' +
       'then fork fails ' +
       'and the reason given is dojo' do
    stub_dojo
    fork('bad', 'hippo', 1)
    refute forked?
    assert_reason_is('dojo')
    assert_nil forked_kata_id
    assert_equal({ }, git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'when language folder no longer exists ' +
       'the fork fails ' +
       'and the reason given is language' do
    stub_dojo
    id = '1234512345'
    kata = @dojo.katas[id]
    language_name = 'doesNot-Exist'
    kata.dir.write('manifest.json', { :language => language_name })
    fork(id,'hippo',1)
    refute forked?
    assert_reason_is('language')
    assert_equal language_name, json['language']
    assert_nil forked_kata_id
    assert_equal({ }, git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when avatar not started ' +
       'the fork fails ' +
       'and the reason given is avatar' do
    stub_dojo
    language = @dojo.languages['Ruby-Approval']
    language.dir.make
    language.dir.write('manifest.json', {
      :display_name => 'Ruby, Approval'
    })
    id = '1234512345'
    kata = @dojo.katas[id]
    kata.dir.write('manifest.json', { :language => language.name })
    fork(id,'hippo',1)
    refute forked?
    assert_reason_is('avatar')
    assert_equal 'hippo', json['avatar']
    assert_nil forked_kata_id
    assert_equal({ }, git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when tag is bad ' +
       'the fork fails ' +
       'and the reason given is traffic_light' do
    bad_tag_test('xx')      # !is_tag
    bad_tag_test('-14')     # tag <= 0
    bad_tag_test('-1')      # tag <= 0
    bad_tag_test('0')       # tag <= 0
    bad_tag_test('2',true)  # tag > avatar.lights.length
  end

  def bad_tag_test(bad_tag, more_than_number_of_lights = false)
    stub_dojo
    language_name = 'Ruby-Approval'
    language = @dojo.languages[language_name]
    language.dir.make
    language.dir.write('manifest.json', {
      :display_name => 'Ruby, Approval'
    })
    id = '1234512345'
    kata = @dojo.katas[id]
    kata.dir.make
    kata.dir.write('manifest.json', { :language => language_name })
    avatar_name = 'hippo'
    avatar = kata.avatars[avatar_name]
    avatar.dir.make
    if more_than_number_of_lights
      stub_traffic_lights(avatar, red)
    end
    fork(id,avatar_name,bad_tag)
    refute forked?
    assert_reason_is('traffic_light')
    assert_nil forked_kata_id
    assert_equal({ }, git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when the exercise no longer exists but everything else ' +
       "is ok then fork works and the new dojos id is returned" do
    stub_setup
    fork(@id,@avatar_name,@tag)
    assert forked?
    exercise = @dojo.exercises['fake-Yatzy']
    exercise.dir.delete('instructions')
    fork(@id,@avatar_name,@tag)
    assert forked?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when language has been renamed but new-name-language exists ' +
       'and id,avatar,tag are all ok ' +
       'the fork works ' +
       "and the new dojo's id is returned" do
    stub_dojo
    id = '1234512345'
    kata = @dojo.katas[id]
    old_language_name = 'C#'
    kata.dir.write('manifest.json', { :language => old_language_name })
    new_language_name = 'C#-NUnit'
    language = @dojo.languages[new_language_name]
    language.dir.write('manifest.json', { 
      :display_name => 'C#, NUnit',
      :unit_test_framework => 'fake' 
    })
    avatar_name = 'hippo'
    avatar = kata.avatars[avatar_name]
    stub_traffic_lights(avatar, [ red, green ])
    visible_files = { 'Hiker.cs' => 'public class Hiker { }',
                      'HikerTest.cs' => 'using NUnit.Framework;' }
    manifest = JSON.unparse(visible_files)
    tag = 2
    filename = 'manifest.json'
    git.spy(avatar.dir.path,'show',"#{tag}:#{filename}",manifest)
    fork(id,avatar_name,tag)
    assert forked?
    assert_equal 10, forked_kata_id.length
    assert_not_equal id, forked_kata_id
    forked_kata = @dojo.katas[forked_kata_id]
    assert forked_kata.exists?
    assert_equal kata.language.name, forked_kata.language.name
    assert_equal kata.exercise.name, forked_kata.exercise.name
    assert_equal visible_files, forked_kata.visible_files
    assert_equal({avatar.path => [ ['show', '2:manifest.json']]}, git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id,language,avatar,tag are all ok ' +
       'format=json fork works ' +
       "and the new dojo's id is returned" do
    stub_setup
    fork(@id,@avatar_name,@tag)
    assert forked?
    assert_equal 10, forked_kata_id.length
    assert_not_equal @id, forked_kata_id
    forked_kata = @dojo.katas[forked_kata_id]
    assert forked_kata.exists?
    assert_equal @kata.language.name, forked_kata.language.name
    assert_equal @kata.exercise.name, forked_kata.exercise.name
    assert_equal @visible_files, forked_kata.visible_files
    assert_equal({@avatar.path => [ ['show', '2:manifest.json']]}, git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id,language,avatar,tag are all ok ' +
       'format=html fork works ' +
       'and you are redirected to the home page ' +
       "with the new dojo's id" do
    stub_setup
    fork(@id,@avatar_name,@tag,:html)
    assert_response :redirect
    assert @response.location.include? '/dojo/index/'
  end

  #- - - - - - - - - - - - - - - - - -
  
  def stub_setup
    stub_dojo
    @id = '1234512345'
    @kata = @dojo.katas[@id]
    language_name = 'Ruby-TestUnit'
    exercise_name = 'fake-Yatzy'
    stub_kata(@id, language_name, exercise_name)
    language = @dojo.languages[language_name]
    language.dir.write('manifest.json', { 
      :display_name => 'Ruby, TestUnit',
      :unit_test_framework => 'ruby_test_unit' 
    })
    @avatar_name = 'hippo'
    @avatar = @kata.avatars[@avatar_name]
    stub_traffic_lights(@avatar, [ red, green ])
    @visible_files = { 'Hiker.cs' => 'public class Hiker { }', 
                      'HikerTest.cs' => 'using NUnit.Framework;' }
    manifest = JSON.unparse(@visible_files)
    @tag = 2
    filename = 'manifest.json'
    git.spy(@avatar.dir.path, 'show', "#{@tag}:#{filename}",manifest)
  end

  def fork(id, avatar, tag,format = :json)
    get 'forker/fork', format:format, id:id, avatar:avatar, tag:tag
  end
  
  def stub_traffic_lights(avatar, lights)
    avatar.dir.write('increments.json', lights)
  end

  def red
    { 'colour' => 'red' }
  end

  def green
    { 'colour' => 'green' }
  end

  def forked?
    refute_nil json
    json['forked']
  end

  def forked_kata_id
    refute_nil json
    json['id']
  end

  def assert_reason_is(expected)
    refute_nil json
    assert_equal expected, json['reason']
  end

end
