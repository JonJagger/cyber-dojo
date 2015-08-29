#!/usr/bin/env ../test_wrapper.sh app/controllers

require_relative 'controller_test_base'
require 'digest/md5'

class HashMaker

  def initialize(avatar)
    @visible_files = avatar.visible_files
    @incoming,@outgoing = {},{}
    avatar.visible_files.each do |filename,content|
      @incoming[filename] = hash(content)
      @outgoing[filename] = hash(content)
    end
  end

  attr_reader :hash

  def new_file(filename,content)
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def delete_file(filename)
    assert @visible_files.keys.include? filename
    @visible_files.delete(filename)
    @outgoing.delete(filename)
  end

  def change_file(filename,content)
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def params
    {
      :file_content => @visible_files,
      :file_hashes_incoming => @incoming,
      :file_hashes_outgoing => @outgoing
    }
  end

private

  def hash(content)
    Digest::MD5.hexdigest(content)
  end

end

# ===============================================================

class ReverterControllerTest  < ControllerTestBase

  test 'revert' do
    @id = create_kata
    enter
    avatar = katas[@id].avatars[@avatar_name]
    kata_edit

    filename = 'cyber-dojo.sh'
    hash_maker = HashMaker.new(avatar)
    hash_maker.change_file(filename, old_content='echo abc')
    kata_run_tests hash_maker.params  #1
    assert_response :success
    assert_equal old_content,avatar.visible_files[filename]

    hash_maker = HashMaker.new(avatar)
    hash_maker.change_file(filename, new_content='something different')
    kata_run_tests hash_maker.params #2
    assert_response :success
    assert_equal new_content,avatar.visible_files[filename]

    get 'reverter/revert', :format => :json,
                           id:@id,
                           avatar:@avatar_name,
                           tag:1
    assert_response :success

    visible_files = json['visibleFiles']
    assert_not_nil visible_files
    assert_not_nil visible_files['output']
    assert_not_nil visible_files[filename]
    assert_equal old_content, visible_files[filename]
  end

end
