#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class KataTests < AppModelsTestBase

  test 'F3B8B1',
  'attempting to access a Kata with an invalid is nil' do
    bad_ids = [
      nil,          # not string
      Object.new,   # not string
      '',           # too short
      '123456789',  # too short
      '123456789f', # not 0-9A-F
      '123456789S'  # not 0-9A-F
    ]
    bad_ids.each do |bad_id|
      begin
        kata = katas[bad_id]
        assert_nil kata
      rescue StandardError
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '677A57',
  'id reads back as set' do
    id = unique_id
    kata = make_kata({ id:id })
    assert_equal id, kata.id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '66C9AE',
    'when kata has no avatars' +
       ' then it is not active ' +
       ' and its age is zero' do
    kata = make_kata
    refute kata.active?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B9340E',
    "when kata's avatars have 0 traffic-lights" +
       ' then it is not active ' +
       ' and its age is zero' do
    kata = make_kata
    kata.start_avatar(['hippo'])
    kata.start_avatar(['lion'])
    refute kata.active?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F2CDD3',
    'when kata has at least one avatar with 1 or more traffic-lights' +
       ' then kata is active ' +
       ' and age is from earliest traffic-light to now' do
    kata = make_kata

    hippo = kata.start_avatar(['hippo'])
    first_time = [2014, 2, 15, 8, 54, 6]
    DeltaMaker.new(hippo).run_test(first_time)

    lion = kata.start_avatar(['lion'])
    second_time = [2014, 2, 15, 8, 54, 34]
    DeltaMaker.new(lion).run_test(second_time)

    assert kata.active?
    now = first_time
    now[seconds_slot = 5] += 17
    assert_equal 17, kata.age(now)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '78A205',
  'make_kata with default-now uses-time-now' do
    now = Time.now
    kata = make_kata
    created = Time.mktime(*kata.created)
    past = Time.mktime(now.year, now.month, now.day, now.hour, now.min, now.sec)
    diff = created - past
    assert 0 <= diff && diff <= 1, "created=#{created}, past=#{past}, diff=#{past}"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6AF51F',
    'kata.id, kata.created, kata.language_name,' +
       'kata.exercise_name, kata.visible_files ' +
       'all read from manifest' do
    language = languages['Java-JUnit']
    exercise = exercises['Fizz_Buzz']
    id = unique_id
    now = [2014, 7, 17, 21, 15, 45]
    kata = katas.create_kata(language, exercise, id, now)
    assert_equal id, kata.id.to_s
    assert_equal Time.mktime(*now), kata.created
    assert_equal language.name, kata.language.name
    assert_equal exercise.name, kata.exercise.name
    assert_equal exercise.instructions, kata.visible_files['instructions']
    assert_equal '', kata.visible_files['output']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '139C43',
    'start_avatar with specific avatar-name' +
       ' (useful for testing) succeeds if avatar has not yet started' do
    kata = make_kata
    hippo = kata.start_avatar(['hippo'])
    assert_equal 'hippo', hippo.name
    assert_equal ['hippo'], kata.avatars.map(&:name)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A653FA',
    'start_avatar with specific avatar-name' +
       ' (useful for testing) fails if avatar has already started' do
    kata = make_kata
    kata.start_avatar(['hippo'])
    avatar = kata.start_avatar(['hippo'])
    assert_nil avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4C66C8',
    'start_avatar with specific avatar-names arg is used' +
       '(useful for testing)' do
    kata = make_kata
    names = %w(panda lion cheetah)
    panda = kata.start_avatar(names)
    assert_equal 'panda', panda.name
    lion = kata.start_avatar(names)
    assert_equal 'lion', lion.name
    cheetah = kata.start_avatar(names)
    assert_equal 'cheetah', cheetah.name
    assert_nil kata.start_avatar(names)
    avatars_names = kata.avatars.map(&:name)
    assert_equal names.sort, avatars_names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '08141A',
  'start_avatar succeeds once for each avatar name then fails' do
    kata = make_kata
    created = []
    Avatars.names.length.times do
      avatar = kata.start_avatar
      refute_nil avatar
      created << avatar
    end
    assert_equal Avatars.names.sort, created.collect(&:name).sort
    avatar = kata.start_avatar
    assert_nil avatar
  end

end
