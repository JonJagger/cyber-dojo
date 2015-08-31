#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class KatasTests < ModelTestBase

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

  #- - - - - - - - - - - - - - - -

  test 'create_kata saves empty started_avatars.json file' do
    id = unique_id
    kata = make_kata(id)
    filename = 'started_avatars.json'
    assert kata.dir.exists?(filename), 'exists'
    started = JSON.parse(kata.dir.read(filename))
    assert_equal [],started
  end

  #- - - - - - - - - - - - - - - -

  test 'katas[id] returns previously created kata with given id' do
    kata = make_kata
    k = katas[kata.id.to_s]
    assert_not_nil k
    assert_equal k.id.to_s, kata.id.to_s
  end

  #- - - - - - - - - - - - - - - -

  test 'katas.each() returns all currently created katas' do
    kata1 = make_kata
    kata2 = make_kata
    ids = katas.each.map{|kata| kata.id.to_s.gsub('/','') }
    assert_equal [kata1.id.to_s,kata2.id.to_s].sort, ids.sort
  end

  #- - - - - - - - - - - - - - - -
  
  test 'is Enumerable, eg each not needed if doing map' do
    kata1 = make_kata
    kata2 = make_kata
    ids = katas.map{|kata| kata.id.to_s.gsub('/','') }
    assert_equal [kata1.id.to_s,kata2.id.to_s].sort, ids.sort    
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false when id not a string' do
    not_string = Object.new
    assert !katas.valid?(not_string)
    assert !katas.exists?(not_string)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false when string is not 10 chars long' do
    nine = unique_id[0..-2]
    assert_equal 9, nine.length
    assert !katas.valid?(nine)
    assert !katas.exists?(nine)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false when string has non-hex chars' do
    has_a_g = '123G56789'
    assert !katas.valid?(has_a_g)
    assert !katas.exists?(has_a_g)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) but !exists?(id)' do
    id = '123456789A'
    assert katas.valid?(id)
    assert !katas.exists?(id)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id)' do
    id = make_kata.id
    assert katas.valid?(id)
    assert katas.exists?(id), "X"
  end

end
