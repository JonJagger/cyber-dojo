#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class AvatarsTests < ModelTestBase

  id['631149'].test\
  'there are 16 avatar names' do
    assert_equal 16, Avatars.names.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  id['E7A60F'].test\
  'avatars names all begin with a different letter' do
    first_letters = Avatars.names.collect{|name| name[0]}.uniq
    assert_equal first_letters.length, Avatars.names.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  id['B6F12F'].test\
  'avatars.each is [] when empty' do
    kata = make_kata
    assert_equal [], kata.avatars.to_a
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  id['B85F79'].test\
  'avatars returns all avatars started in the kata' do
    kata = make_kata
    kata.start_avatar([cheetah])
    kata.start_avatar([lion])
    assert_equal [cheetah,lion], kata.avatars.map{|avatar| avatar.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  
  id['B11555'].test\
  'avatars.map works' do
    kata = make_kata
    kata.start_avatar([cheetah])
    kata.start_avatar([lion])
    assert_equal [cheetah,lion], kata.avatars.map{|avatar| avatar.name}.sort    
    assert_equal 2, kata.avatars.to_a.length
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  id['1F9350'].test\
  'katas[id].avatars returns all avatars started in the kata with that id' do
    kata = make_kata
    kata.start_avatar([lion])
    kata.start_avatar([hippo])
    expected_names = [lion, hippo]
    names = katas[kata.id.to_s].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  id['6A074D'].test\
  'katas[id].avatars[panda] finds the panda' do
    kata = make_kata
    kata.start_avatar([panda])
    assert_equal [panda], kata.avatars.map{|avatar| avatar.name}
    assert_equal panda, katas[kata.id.to_s].avatars[panda].name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  def cheetah; 'cheetah'; end
  def lion; 'lion'; end
  def hippo; 'hippo'; end
  def panda; 'panda'; end
  
end
