#!/usr/bin/env ruby

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

  test 'path must end in /' do
    path = 'unslashed'
    set_katas_root(path)
    assert_raises(RuntimeError) { katas.path }
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

  test 'complete(id=nil) is ""' do
    assert_equal "", katas.complete(nil)
  end

  #- - - - - - - - - - - - - - - -

  test 'complete(id="") is ""' do
    assert_equal '', katas.complete('')
  end

  #- - - - - - - - - - - - - - - -

  test 'complete(id): unchanged when no candidates' do
    assert_equal '23', katas.complete('23')
  end

  #- - - - - - - - - - - - - - - -

  test 'complete(id): id unchanged when id is less than 4 chars in length ' +
       'because trying to complete from a short id will waste time going through ' +
       'lots of candidates with the likely outcome of no unique result' do
    id = make_kata.id[0..2]
    assert_equal 3, id.length
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - -

  test 'complete(id): id unchanged when 4 chars long' do
    id = make_kata.id
    assert_equal id, @dojo.katas.complete(id[0..3])
  end

  #- - - - - - - - - - - - - - - -

  test 'complete(id): id unchanged when 2+ matches' do
    prefix = unique_id[0..-2]
    assert_equal 10-1, prefix.length
    id1 = prefix + 'B'
    kata1 = make_kata(id1)
    assert_equal id1, kata1.id
    id2 = prefix + 'C'
    kata2 = make_kata(id2)
    assert_equal id2, kata2.id
    assert_equal prefix, katas.complete(prefix)
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
    assert !@dojo.katas.valid?(nine)
    assert !@dojo.katas.exists?(nine)
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

  #- - - - - - - - - - - - - - - -
  
  def katas
    @dojo.katas
  end
  
end
