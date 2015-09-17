#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'

class KataTests < AppModelTestBase

  test 'F3B8B1',
  'attempting to create a Kata with an invalid id raises a RuntimeError' do
    bad_ids = [
      nil,          # not string
      Object.new,   # not string
      '',           # too short
      '123456789',  # too short
      '123456789f', # not 0-9A-F
      '123456789S'  # not 0-9A-F
    ]
    bad_ids.each do |bad_id|
      assert_raises(RuntimeError) { katas[bad_id] }
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '677A57',
  'id reads back as set' do
    id = unique_id
    kata = katas[id]    
    assert_equal id, kata.id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6F3999',
  "kata's path has correct format" do
    kata = katas[unique_id]
    assert correct_path_format?(kata)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1E4B7A',
  'path is split ala git' do
    kata = katas[unique_id]
    split = kata.id[0..1] + '/' + kata.id[2..-1]
    assert kata.path.include?(split)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'C11AFC',
  'exists? is false before dir is made' do
    kata = katas[unique_id]
    refute kata.exists?
    kata.dir.make
    assert kata.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8EA395',
    'when kata does not exist' +
       ' then it is not active' +
       ' and it has not finished' +
       ' and its age is zero' do
    kata = katas[unique_id]
    refute kata.exists?
    refute kata.active?
    refute kata.finished?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '66C9AE',
    'when kata exists but has no avatars' +
       ' then it is not active ' +
       ' and it has not finished ' +
       ' and its age is zero' do
    kata = make_kata
    assert kata.exists?
    refute kata.active?
    refute kata.finished?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test '9ECF8D',
  'start_avatar puts started avatars name into katas started_avatars.json file' do
    kata = make_kata
    kata.start_avatar(['hippo'])
    started = JSON.parse(kata.read('started_avatars.json'))
    assert_equal ['hippo'], started
    kata.start_avatar(['lion'])
    started = JSON.parse(kata.read('started_avatars.json'))
    assert_equal ['hippo','lion'], started.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9A1C97',
    'start_avatar on old dojo that as no started_avatars.json file' +
       ' reverts to doing dir.exists? for each avatar' do
   kata = make_kata
   animals = ['lion','hippo','cheetah'].sort
   3.times { kata.start_avatar(animals) }
   filename = 'started_avatars.json'
   started = JSON.parse(kata.read(filename))
   assert_equal animals, started.sort
   # now delete started_avatars.json to simulate old dojo
   # with started avatars and no started_avatars.json file
   kata.dir.delete(filename)
   refute kata.dir.exists?(filename)
   (Avatars.names.size - 3).times do
     avatar = kata.start_avatar
     refute_nil avatar
     refute kata.dir.exists?(filename)
   end
   avatar = kata.start_avatar
   assert_nil avatar
   refute kata.dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B9340E',
    'when kata exists but all its avatars have 0 traffic-lights' +
       ' then it is not active ' +
       ' and it has not finished' +
       ' and its age is zero' do
    kata = make_kata
    kata.start_avatar(['hippo'])
    kata.start_avatar(['lion'])
    refute kata.active?
    refute kata.finished?
    assert_equal 0, kata.age
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'F2CDD3',
    'when kata exists and at least one avatar has 1 or more traffic-lights' +
       ' then kata is active ' +
       ' and age is from earliest traffic-light to now' +
       ' and finishes when age >= 1 day' do
    kata = make_kata
    hippo = kata.start_avatar(['hippo'])
    lion = kata.start_avatar(['lion'])
    first =
      {
        'colour' => 'red',
        'time' => [2014, 2, 15, 8, 54, 6],
        'number' => 1
      }

    second =
      {
        'colour' => 'green',
        'time' => [2014, 2, 15, 8, 54, 34],
        'number' => 2
      }

    hippo.dir.write('increments.json', [second])
    lion.dir.write('increments.json', [first])

    assert kata.active?
    now = first['time']
    now[seconds=5] += 17
    refute kata.finished?(now), "!kata.finished?(one-second-old)"
    assert_equal 17, kata.age(now)

    now = first['time']
    now[minutes=4] += 1
    refute kata.finished?(now), "!kata.finished?(one-minute-old)"
    
    now = first['time']
    now[hours=3] += 1
    refute kata.finished?(now), "!kata.finished?(one-hour-old)"
    
    now = first['time']
    now[days=2] += 1
    assert kata.finished?(now), "kata.finished?(one-day-old)"
    
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

  test 'CE9083',
  'make_kata saves manifest in kata dir' do
    kata = make_kata
    assert kata.dir.exists?('manifest.json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6AF51F',
    'kata.id, kata.created, kata.language_name,' +
       'kata.exercise_name, kata.visible_files ' +
       'all read from manifest' do
    language = languages['Java-JUnit']
    exercise = exercises['Fizz_Buzz']
    now = [2014,7,17,21,15,45]
    id = unique_id
    kata = katas.create_kata(language, exercise, id, now)
    assert_equal id, kata.id.to_s
    assert_equal Time.mktime(*now), kata.created
    assert_equal language.name, kata.language.name
    assert_equal exercise.name, kata.exercise.name
    assert_equal '', kata.visible_files['output']
    assert kata.visible_files['instructions'].start_with?('Note: The initial code')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '139C43',
    'start_avatar with specific avatar-name' +
       ' (useful for testing) succeeds if avatar has not yet started' do
    kata = make_kata
    hippo = kata.start_avatar(['hippo'])
    assert_equal 'hippo', hippo.name
    assert_equal ['hippo'], kata.avatars.map {|avatar| avatar.name}
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A653FA',
    'start_avatar with specific avatar-name' +
       ' (useful for testing) fails if avatar has already started' do
    kata = make_kata
    hippo = kata.start_avatar(['hippo'])
    avatar = kata.start_avatar(['hippo'])
    assert_nil avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test '4C66C8',
    'start_avatar with specific avatar-names arg is used' +
       '(useful for testing)' do
    kata = make_kata
    names = [ 'panda', 'lion', 'cheetah' ]
    panda = kata.start_avatar(names)
    assert_equal 'panda', panda.name
    lion = kata.start_avatar(names)
    assert_equal 'lion', lion.name
    cheetah = kata.start_avatar(names)
    assert_equal 'cheetah', cheetah.name
    assert_nil kata.start_avatar(names)
    avatars_names = kata.avatars.map {|avatar| avatar.name}
    assert_equal names.sort, avatars_names.sort
  end
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test '08141A',
  'start_avatar succeeds once for each avatar name then fails' do
    kata = make_kata
    created = [ ]
    Avatars.names.length.times do |n|      
      avatar = kata.start_avatar
      refute_nil avatar
      created << avatar
    end
    assert_equal Avatars.names.sort, created.collect{|avatar| avatar.name}.sort
    avatar = kata.start_avatar
    assert_nil avatar
  end
     
end
