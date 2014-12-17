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
    ids = @dojo.katas.map{|kata| kata.id.to_s.gsub('/','') }
    assert_equal [kata1.id.to_s,kata2.id.to_s].sort, ids.sort
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
    assert @dojo.katas.exists?(id)
  end

end
