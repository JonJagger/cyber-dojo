#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'

class AvatarsTests < AppModelTestBase

  test '631149',
  'there are 64 avatar names' do
    assert_equal 64, Avatars.names.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B6F12F',
  'avatars.each is [] when empty' do
    kata = make_kata
    assert_equal [], kata.avatars.to_a
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B85F79',
  'avatars returns all avatars started in the kata' do
    kata = make_kata
    assert_equal [], kata.avatars.names.sort
    kata.start_avatar([cheetah])
    assert_equal [cheetah], kata.avatars.names.sort
    kata.start_avatar([lion])
    assert_equal [cheetah, lion], kata.avatars.names
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A95F3F',
  'avatars returns all avatars started in the kata' +
    ' and creates started_avatars.json file if it does not already exist' do
    kata = make_kata
    animals = %w(deer panda snake)
    animals.size.times { kata.start_avatar(animals) }
    File.delete(kata.path + 'started_avatars.json')
    assert_equal animals.sort, kata.avatars.names.sort
    assert_equal animals.sort, dir_of(kata).read_json('started_avatars.json').sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B11555',
  'avatars.map works' do
    kata = make_kata
    kata.start_avatar([cheetah])
    kata.start_avatar([lion])
    assert_equal [cheetah, lion], kata.avatars.names.sort
    assert_equal 2, kata.avatars.to_a.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3D8638',
  'avatars[invalid-name] is nil' do
    kata = make_kata
    assert_nil kata.avatars[invalid_name = 'mobile-phone']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '299429',
  'avatars[cheetah] is nil when cheetah has not started' do
    kata = make_kata
    assert_nil kata.avatars[cheetah]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6A074D',
  'avatars[panda] is the panda when the panda has started' do
    kata = make_kata
    kata.start_avatar([panda])
    assert_equal [panda], kata.avatars.names
    assert_equal panda, katas[kata.id.to_s].avatars[panda].name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1F9350',
  'avatars returns all avatars started in the kata with that id' do
    kata = make_kata
    kata.start_avatar([lion])
    kata.start_avatar([hippo])
    expected_names = [lion, hippo]
    actual_names = kata.avatars.names
    assert_equal expected_names.sort, actual_names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def cheetah; 'cheetah'; end
  def lion   ; 'lion'   ; end
  def hippo  ; 'hippo'  ; end
  def panda  ; 'panda'  ; end

end
