#!/bin/bash ../test_wrapper.sh

require_relative 'controller_test_base'
require 'digest/md5'

class ParamsMaker

  def initialize(avatar)
    @visible_files = avatar.visible_files
    @incoming,@outgoing = {},{}
    avatar.visible_files.each do |filename,content|
      @incoming[filename] = hash(content)
      @outgoing[filename] = hash(content)
    end
  end

  def new_file(filename,content)
    refute { @visible_files.keys.include?(filename) }
    @visible_files[filename] = content
    @outgoing[filename] = hash(content)
  end

  def delete_file(filename)
    assert { @visible_files.keys.include?(filename) }
    @visible_files.delete(filename)
    @outgoing.delete(filename)
  end

  def change_file(filename,content)
    assert { @visible_files.keys.include?(filename) }
    refute { @visible_files[filename] == content }
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

  def assert(&block)
    raise RuntimeError.new('DeltaMaker.assert') if !block.call
  end

  def refute(&block)
    raise RuntimeError.new('DeltaMaker.refute') if block.call
  end

end

# ===============================================================

class RunnerStubAdapter

  def method_missing(sym, *args, &block)
    @@runner ||= RunnerStub.new
    @@runner.send(sym, *args, &block)
  end

  def self.reset
    @@runner = nil
  end

end

# ===============================================================

class ReverterControllerTest  < ControllerTestBase

  test 'revert' do
    set_runner_class_name('RunnerStubAdapter')
    @id = create_kata('Java, JUnit')
    enter
    avatar = katas[@id].avatars[@avatar_name]
    kata_edit

    filename = 'Hiker.java'
    assert avatar.visible_files.keys.include?(filename)
    # 1
    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, old_content='echo abc')
    runner.stub_output('dummy')
    kata_run_tests params_maker.params
    assert_response :success
    assert_equal old_content,avatar.visible_files[filename]
    # 2
    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, new_content='something different')
    runner.stub_output('dummy')
    kata_run_tests params_maker.params
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
