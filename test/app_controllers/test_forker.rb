#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'
require_relative './RailsRunnerStubThreadAdapter'

class ForkerControllerTest < AppControllerTestBase

  def setup
    super
    set_runner_class('RailsRunnerStubThreadAdapter')
    RailsRunnerStubThreadAdapter.reset
    @id = create_kata('Java, JUnit')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '892AFE',
  'when id is invalid ' +
    'then fork fails ' +
      'and the reason given is dojo' do
    fork(id = 'bad-id', 'hippo', tag = 1)
    refute forked?
    assert_reason_is('dojo')
    assert_nil forked_kata_id
    assert_equal([], git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'EAE021',
  'when language folder no longer exists ' +
      'the fork fails ' +
        'and the reason given is language' do
    kata = katas[@id]
    language_name = 'doesNot-Exist'
    dir_of(kata).make
    dir_of(kata).write_json('manifest.json', { language: language_name })
    fork(@id, 'hippo', tag = 1)
    refute forked?
    assert_reason_is('language')
    assert_equal language_name, json['language']
    assert_nil forked_kata_id
    assert_equal([], git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '67725B',
  'when avatar not started ' +
    'the fork fails ' +
      'and the reason given is avatar' do
    fork(@id, 'hippo', tag = 1)
    refute forked?
    assert_reason_is('avatar')
    assert_equal 'hippo', json['avatar']
    assert_nil forked_kata_id
    assert_equal([], git.log)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4CCCA7',
  'when tag is bad ' +
    'the fork fails ' +
      'and the reason given is traffic_light' do
    @avatar = enter
    bad_tag_test('xx')      # !is_tag
    bad_tag_test('-14')     # tag <= 0
    bad_tag_test('-1')      # tag <= 0
    bad_tag_test('0')       # tag <= 0

    runner.stub_output('dummy')
    run_tests
    bad_tag_test('2')       # tag > avatar.lights.length
  end

  def bad_tag_test(bad_tag)
    fork(@id, @avatar.name, bad_tag)
    refute forked?
    assert_reason_is('traffic_light')
    assert_nil forked_kata_id
    assert_equal([], git.log)
  end


  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2C432F',
  'when id,language,avatar,tag are all ok ' +
    'format=json fork works ' +
      "and the new dojo's id is returned" do
    @avatar = enter # 0
    runner.stub_output('dummy')
    run_tests       # 1

    fork(@id, @avatar.name, tag = 1)
    assert forked?
    assert_equal 10, forked_kata_id.length
    assert_not_equal @id, forked_kata_id
    forked_kata = katas[forked_kata_id]
    assert_not_nil forked_kata
    kata = @avatar.kata
    assert_equal kata.language.name, forked_kata.language.name
    assert_equal kata.exercise.name, forked_kata.exercise.name

    assert_equal kata.visible_files.tap{|hs| hs.delete('output')},
           forked_kata.visible_files.tap{|hs| hs.delete('output')}
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F65835',
  'when id,language,avatar,tag are all ok ' +
    'format=html fork works ' +
      'and you are redirected to the home page ' +
        "with the new dojo's id" do
    @avatar = enter # 0
    runner.stub_output('dummy')
    run_tests       # 1

    fork(@id, @avatar.name, tag = 1, :html)

    assert_response :redirect
    url = /(.*)\/dojo\/index\/(.*)/
    m = url.match(@response.location)
    forked_kata_id = m[2]
    assert katas[forked_kata_id].exists?
  end

  #- - - - - - - - - - - - - - - - - -

  test '5EA04E',
  'when the exercise no longer exists and everything else ' +
     'is ok then fork works and the new dojos id is returned' do
    @avatar = enter # 0
    runner.stub_output('dummy')
    run_tests       # 1
    dir = disk[katas[@id].path]
    json = dir.read_json('manifest.json')
    not_exercise_name = 'exercise-name-that-does-not-exist'
    assert_nil exercises[not_exercise_name]
    json['exercise'] = not_exercise_name
    dir.write_json('manifest.json', json)
    fork(@id, @avatar.name, tag = 1)
    assert forked?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9D85BF',
  'when language has been renamed and everything else ' +
    'is ok then fork works and the new dojos id is returned' do
    @avatar = enter # 0
    runner.stub_output('dummy')
    run_tests       # 1
    dir = disk[katas[@id].path]
    json = dir.read_json('manifest.json')
    old_language_name = 'C#'
    assert_not_nil languages[old_language_name]
    json['language'] = old_language_name
    dir.write_json('manifest.json', json)
    fork(@id, @avatar.name, tag = 1)
    assert forked?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def fork(id, avatar, tag, format = :json)
    get 'forker/fork', format:format, id:id, avatar:avatar, tag:tag
  end

  def forked?
    refute_nil json
    json['forked']
  end

  def assert_reason_is(expected)
    refute_nil json
    assert_equal expected, json['reason']
  end

  def forked_kata_id
    refute_nil json
    json['id']
  end

end
