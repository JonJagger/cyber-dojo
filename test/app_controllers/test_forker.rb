#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class ForkerControllerTest < AppControllerTestBase

  test '892AFE',
  'when id is invalid ' +
    'then fork fails ' +
      'and the reason given is dojo' do
    fork(bad_id = 'bad-id', 'hippo', tag = 1)
    refute forked?
    assert_reason_is("dojo(#{bad_id})")
    assert_nil forked_kata_id
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'EAE021',
  'when language no longer exists, the fork fails, and the reason given is language' do
    id = unique_id
    language = languages['C#-NUnit']
    bad_language = 'does-not-exist'
    manifest = {
                       id: id,
                  created: [2016,1,9,17,50,45],
                 language: bad_language,
                 exercise: default_exercise_name,
      unit_test_framework: language.unit_test_framework,
                 tab_size: language.tab_size
    }
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = 'your task...'
    kata = katas.create_kata_from_manifest(manifest)

    fork(kata.id, 'hippo', tag = 1)
    refute forked?
    assert_reason_is("language(#{bad_language})")
    assert_nil forked_kata_id
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '67725B',
  'when avatar not started, the fork fails, and the reason given is avatar' do
    id = create_kata
    fork(id, bad_avatar = 'hippo', tag = 1)
    refute forked?
    assert_reason_is("avatar(#{bad_avatar})")
    assert_nil forked_kata_id
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4CCCA7',
  'when tag is bad, the fork fails, and the reason given is traffic_light' do
    @id = create_kata
    @avatar = start
    bad_tag_test('xx')      # !is_tag
    bad_tag_test('-14')     # tag <= 0
    bad_tag_test('-1')      # tag <= 0
    bad_tag_test('0')       # tag <= 0
    run_tests
    bad_tag_test('2')       # tag > avatar.lights.length
  end

  def bad_tag_test(bad_tag)
    fork(@id, @avatar.name, bad_tag)
    refute forked?
    assert_reason_is("traffic_light(#{bad_tag})")
    assert_nil forked_kata_id
  end


  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2C432F',
  'when id,language,avatar,tag are all ok ' +
    'format=json fork works ' +
      "and the new dojo's id is returned" do
    @id = create_kata
    @avatar = start # 0
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

    assert_equal kata.visible_files.tap { |hs| hs.delete('output') },
           forked_kata.visible_files.tap { |hs| hs.delete('output') }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F65835',
  'when id,language,avatar,tag are all ok ' +
    'format=html fork works ' +
      'and you are redirected to the enter page ' +
        "with the new dojo's id" do
    @id = create_kata
    @avatar = start # 0
    run_tests       # 1
    fork(@id, @avatar.name, tag = 1, :html)
    assert_response :redirect
    url = /(.*)\/enter\/show\/(.*)/
    m = url.match(@response.location)
    forked_kata_id = m[2]
  end

  #- - - - - - - - - - - - - - - - - -

  test '5EA04E',
  'when the exercise no longer exists and everything else ' +
     'is ok then fork works and the new dojos id is returned' do
    @id = unique_id
    language = languages[default_language_name]
    manifest = {
                       id: @id,
                  created: [2016,1,9,17,50,45],
                 language: language.name,
                 exercise: 'exercise-name-that-does-not-exist',
      unit_test_framework: language.unit_test_framework,
                 tab_size: language.tab_size
    }
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = 'your task...'
    kata = katas.create_kata_from_manifest(manifest)
    @id = kata.id
    @avatar = start # 0
    run_tests       # 1

    fork(@id, @avatar.name, tag = 1)
    assert forked?
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9D85BF',
  'when language has been renamed and everything else ' +
    'is ok then fork works and the new dojos id is returned' do
    @id = unique_id
    language = languages['C#-NUnit']
    manifest = {
                       id: @id,
                  created: [2016,1,9,17,50,45],
                 language: 'C#', #old-name
                 exercise: default_exercise_name,
      unit_test_framework: language.unit_test_framework,
                 tab_size: language.tab_size
    }
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = 'your task...'
    kata = katas.create_kata_from_manifest(manifest)
    @id = kata.id
    @avatar = start # 0
    run_tests       # 1

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
