#!/usr/bin/env ruby

require_relative 'model_test_base'

class KatasTests < ModelTestBase

  test 'in test-mode dojo.katas path is not real katas dir' do
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
    katas = @dojo.katas
    ENV.delete('CYBERDOJO_TEST_ROOT_DIR')
    assert katas.path.end_with?('cyber-dojo/test/cyberdojo/katas/')
  end

  #- - - - - - - - - - - - - - - -

  test 'katas[id] returns previously created kata with given id' do
    kata = make_kata
    k = @dojo.katas[kata.id.to_s]
    assert_not_nil k
    assert_equal k.id.to_s, kata.id.to_s
  end

  #- - - - - - - - - - - - - - - -

  test 'katas.each() returns all currently created katas' do
    setup
    kata1 = make_kata
    kata2 = make_kata
    ids = @dojo.katas.each.map{|kata| kata.id.to_s.gsub('/','') }
    assert_equal [kata1.id.to_s,kata2.id.to_s].sort, ids.sort
  end

  #- - - - - - - - - - - - - - - -

  test 'complete(id=nil) is ""' do
    assert_equal "", @dojo.katas.complete(nil)
  end

  test 'complete(id="") is ""' do
    assert_equal '', @dojo.katas.complete('')
  end

  test 'complete(id): unchanged when no candidates' do
    assert_equal '23', @dojo.katas.complete('23')
  end

  test 'complete(id): id unchanged when id is less than 4 chars in length' do
    id = make_kata.id[0..2]
    assert_equal 3, id.length
    assert_equal id, @dojo.katas.complete(id)
  end

  test 'complete(id): id unchanged when 4 chars long' do
    id = make_kata.id
    assert_equal id, @dojo.katas.complete(id[0..3])
  end

  test 'complete(id): id unchanged when 2+ matches' do
    prefix = '12345678A'
    id1 = prefix + 'B'
    kata1 = make_kata(id1)
    assert_equal id1, kata1.id
    id2 = prefix + 'C'
    kata2 = make_kata(id2)
    assert_equal id2, kata2.id
    assert_equal prefix, @dojo.katas.complete(prefix)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false ' +
       'when id not a string' do
    not_string = Object.new
    assert !@dojo.katas.valid?(not_string)
    assert !@dojo.katas.exists?(not_string)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false ' +
       'when string is not 10 chars long' do
    nine = '123456789'
    assert !@dojo.katas.valid?(nine)
    assert !@dojo.katas.exists?(nine)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id) is false ' +
       'when string has non-hex chars' do
    has_a_g = '123G56789'
    assert !@dojo.katas.valid?(has_a_g)
    assert !@dojo.katas.exists?(has_a_g)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) but !exists?(id)' do
    id = '123456789A'
    assert @dojo.katas.valid?(id)
    assert !@dojo.katas.exists?(id)
  end

  #- - - - - - - - - - - - - - - -

  test 'valid?(id) and exists?(id)' do
    id = make_kata.id
    assert @dojo.katas.valid?(id)
    assert @dojo.katas.exists?(id), "X"
  end

end
