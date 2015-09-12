#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class KatasTests < ModelTestBase

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.path
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path is set from ENV' do
    path = 'end_with_slash/'
    set_katas_root(path)
    assert_equal path, katas.path
    assert path_ends_in_slash?(katas)
    assert path_has_no_adjacent_separators?(katas)
  end

  #- - - - - - - - - - - - - - - -

  test 'path is forced to end in a slash' do
    path = 'unslashed'
    set_katas_root(path)
    assert_equal path+'/', katas.path
    assert path_ends_in_slash?(katas)
    assert path_has_no_adjacent_separators?(katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.create_kata()
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'create_kata saves empty started_avatars.json file' do
    id = unique_id
    kata = make_kata(id)
    filename = 'started_avatars.json'
    assert kata.dir.exists?(filename), 'exists'
    started = JSON.parse(kata.read(filename))
    assert_equal [],started
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas[id]
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'katas[id] is kata with given id' do
    kata = make_kata
    k = katas[kata.id.to_s]
    refute_nil k
    assert_equal k.id.to_s, kata.id.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.each()
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'katas.each() yields nothing when there are no katas' do
    assert_equal [], all_ids(katas)
  end

  test 'katas.each() when there is one kata' do
    kata = make_kata
    assert_equal [kata.id.to_s], all_ids(katas)
  end

  test 'katas.each() with two unrelated ids' do
    kata1 = make_kata
    kata2 = make_kata
    assert_equal all_ids([kata1,kata2]).sort, all_ids(katas).sort
  end

  test 'katas.each() with several ids with common first two characters' do
    id = 'ABCDE1234'
    kata1 = make_kata(id + '1')
    kata2 = make_kata(id + '2')
    kata3 = make_kata(id + '3')
    assert_equal all_ids([kata1,kata2,kata3]).sort, all_ids(katas).sort
  end

  test 'is Enumerable: so each not needed if doing map' do
    kata1 = make_kata
    kata2 = make_kata
    assert_equal all_ids([kata1,kata2]).sort, all_ids(katas).sort
  end

  def all_ids(k)
    k.each.map{|kata| kata.id.to_s}
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.complete(id)
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'complete(id=nil) is empty string' do
    assert_equal '', katas.complete(nil)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id="") is empty string' do
    assert_equal '', katas.complete('')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id): does not complete when id is less than 6 chars in length ' +
       'because trying to complete from a short id will waste time going through ' +
       'lots of candidates with the likely outcome of no unique result' do
    id = unique_id[0..4]
    assert_equal 5, id.length
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id): does not complete when 6+ chars long and no matches' do
    id = unique_id[0..5]
    assert_equal 6, id.length
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id) does not complete when 6+ chars and 2+ matches' do
    id = 'ABCDE1'
    make_kata(id + '2345')
    make_kata(id + '2346')
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'complete(id): completes (and uppercases) when 6+ chars and 1 match' do
    id = 'A1B2C3D4E5'
    kata = make_kata(id)
    assert_equal id, katas.complete(id.downcase[0..5])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.valid?(id)
  # katas.exists?(id)
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false when id not a string' do
    not_string = Object.new
    refute katas.valid?(not_string)
    refute katas.exists?(not_string)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false when string is not 10 chars long' do
    nine = unique_id[0..-2]
    assert_equal 9, nine.length
    refute katas.valid?(nine)
    refute katas.exists?(nine)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false when string has non-hex chars' do
    has_a_g = '123G56789'
    refute katas.valid?(has_a_g)
    refute katas.exists?(has_a_g)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) but !exists?(id)' do
    id = '123456789A'
    assert katas.valid?(id)
    refute katas.exists?(id)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id)' do
    id = make_kata.id
    assert katas.valid?(id)
    assert katas.exists?(id)
  end

end
