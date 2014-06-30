#!/usr/bin/env ruby

require_relative 'model_test_base'

class KatasTests < ModelTestBase

  test 'dojo.katas[id] returns previously created kata with given id' do
    kata = make_kata
    k = @dojo.katas[kata.id.to_s]
    assert_not_nil k
    assert_equal k.id.to_s, kata.id.to_s
  end

  #- - - - - - - - - - - - - - - -

  test 'dojo.katas.each() returns all currently created katas' do
    setup
    kata1 = make_kata
    kata2 = make_kata
    ids = @dojo.katas.map{|kata| kata.id.to_s.gsub('/','') }
    assert_equal [kata1.id.to_s,kata2.id.to_s].sort, ids.sort
  end

end
