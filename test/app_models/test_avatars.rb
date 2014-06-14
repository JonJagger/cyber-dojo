#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class AvatarsTests < ModelTestCase

  test "an avatar's format is kata's format which is dojo's format" do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal 'json', avatar.format
    assert_equal 'json', @dojo.format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'kata.avatars() returns all avatars started in the kata' do
    kata = make_kata
    cheetah = kata.start_avatar(['cheetah'])
    lion = kata.start_avatar(['lion'])
    assert_equal ['cheetah','lion'], kata.avatars.map{|avatar| avatar.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.katas[id].avatars() returns all avatars started in kata with given id' do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    hippo = kata.start_avatar(['hippo'])
    expected_names = [lion.name, hippo.name]
    names = @dojo.katas[kata.id.to_s].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.katas[id].avatars[name] finds avatar with given name' do
    kata = make_kata
    panda = kata.start_avatar(['panda'])
    assert_equal ['panda'], kata.avatars.map{|avatar| avatar.name}
    assert_equal 'panda', @dojo.katas[kata.id.to_s].avatars['panda'].name
  end

end
