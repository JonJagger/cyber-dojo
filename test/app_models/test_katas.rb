#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'

class KatasTests < AppModelTestBase

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.path
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B55710',
  'katas path has correct format when set with trailing slash' do
    path = 'slashed/'
    set_katas_root(path)
    assert_equal path, katas.path
    assert correct_path_format?(katas)
  end

  #- - - - - - - - - - - - - - - -

  test 'B2F787',
  'katas path has correct format when set without trailing slash' do
    path = 'unslashed'
    set_katas_root(path)
    assert_equal path + '/', katas.path
    assert correct_path_format?(katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.create_kata()
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B9916D',
  'create_kata saves empty started_avatars.json file' do
    kata = make_kata
    filename = 'started_avatars.json'
    assert dir_of(kata).exists?(filename)
    started = dir_of(kata).read_json(filename)
    assert_equal [],started
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas[id]
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'DFB053',
  'katas[id] is kata with existing id' do
    kata = make_kata
    k = katas[kata.id.to_s]
    refute_nil k
    assert_equal k.id.to_s, kata.id.to_s
  end

  test 'D0A1F6',
  'katas[id] for id that is not a string is nil' do
    not_string = Object.new
    assert_nil katas[not_string]
    nine = unique_id[0..-2]
    assert_equal 9, nine.length
    assert_nil katas[nine]
  end

  test 'A0DF10',
  'katas[id] for 10 digit id with non hex-chars is nil' do
    has_a_g = '123456789G'
    assert_equal 10, has_a_g.length
    assert_nil katas[has_a_g]
  end

  #- - - - - - - - - - - - - - - -

  test '64F53B',
  'katas[id] for non-existing id is nil' do
    id = '123456789A'
    assert_equal 10, id.length
    assert_nil katas[id]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.each()
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '603735',
  'katas.each() yields empty array when there are no katas' do
    dir_of(katas).make
    assert_equal [], all_ids(katas)
  end

  test '5A2932',
  'katas.each() yields array with the one kata-id when there is one kata' do
    kata = make_kata
    assert_equal [kata.id.to_s], all_ids(katas)
  end

  test '24894F',
  'katas.each() with two unrelated ids' do
    kata1 = make_kata
    kata2 = make_kata
    assert_equal all_ids([kata1, kata2]).sort, all_ids(katas).sort
  end

  test '29DFD1',
  'katas.each() with several ids with common first two characters' do
    id = 'ABCDE1234'
    kata1 = make_kata(id + '1')
    kata2 = make_kata(id + '2')
    kata3 = make_kata(id + '3')
    assert_equal all_ids([kata1, kata2, kata3]).sort, all_ids(katas).sort
  end

  test 'F71C21',
  'is Enumerable: so .each not needed if doing map' do
    kata1 = make_kata
    kata2 = make_kata
    assert_equal all_ids([kata1, kata2]).sort, all_ids(katas).sort
  end

  def all_ids(k)
    k.each.map { |kata| kata.id.to_s }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas.complete(id)
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B652EC',
  'complete(id=nil) is empty string' do
    assert_equal '', katas.complete(nil)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D391CE',
  'complete(id="") is empty string' do
    assert_equal '', katas.complete('')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '42EA20',
    'complete(id): does not complete when id is less than 6 chars in length' +
       'because trying to complete from a short id will waste time going through ' +
       'lots of candidates with the likely outcome of no unique result' do
    id = unique_id[0..4]
    assert_equal 5, id.length
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '071A62',
  'complete(id): does not complete when 6+ chars long and no matches' do
    id = unique_id[0..5]
    assert_equal 6, id.length
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '23B4F1',
  'complete(id) does not complete when 6+ chars and 2+ matches' do
    id = 'ABCDE1'
    make_kata(id + '2345')
    make_kata(id + '2346')
    assert_equal id, katas.complete(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0934BF',
  'complete(id): completes (and uppercases) when 6+ chars and 1 match' do
    id = 'A1B2C3D4E5'
    make_kata(id)
    assert_equal id, katas.complete(id.downcase[0..5])
  end

end
