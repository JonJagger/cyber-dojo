#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class AvatarsTests < ModelTestCase

  test "avatar names all begin with a different letter" do
    assert_equal Avatars.names.collect{|name| name[0]}.uniq.length, Avatars.names.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "an avatar's format is kata's format which is dojo's format" do
    kata = make_kata
    avatar = kata.start_avatar
    assert_equal 'json', avatar.format
    assert_equal 'json', @dojo.format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "kata.avatars() returns all avatars started in the kata" do
    kata = make_kata
    assert_equal 0, kata.avatars.length
    lion = kata.start_avatar(['lion'])
    assert_equal 1, kata.avatars.length
    cheetah = kata.start_avatar(['cheetah'])
    assert_equal 2, kata.avatars.length
    expected_names = ['lion', 'cheetah']
    names = kata.avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "dojo.katas[id].avatars() returns all avatars started in kata with given id" do
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    hippo = kata.start_avatar(['hippo'])
    expected_names = [lion.name, hippo.name]
    names = @dojo.katas[kata.id.to_s].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "dojo.katas[id].avatars[name] finds avatar with given name" do
    kata = make_kata
    panda = kata.start_avatar(['panda'])
    assert_equal ['panda'], kata.avatars.map{|avatar| avatar.name}
    assert_equal 'panda', @dojo.katas[kata.id.to_s].avatars['panda'].name
  end

end
