require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../../lib/disk'
require File.dirname(__FILE__) + '/../../lib/git'

class KatasTests < ActionController::TestCase

  def setup
    @disk = Disk.new
    @git = Git.new
    @paas = ExposedLinux::Paas.new(@disk,@git)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path,@format)
    @language = @dojo.languages['Java-JUnit']
    @exercise = @dojo.exercises['Yahtzee']
    `rm -rf #{@paas.path(@dojo.katas)}`
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.make_kata in .rb format" do
    @disk = Disk.new
    @git = Git.new
    @paas = ExposedLinux::Paas.new(@disk,@git)
    @format = 'rb'
    @dojo = @paas.create_dojo(root_path,@format)
    language_name = 'Java-JUnit'
    language = @dojo.languages[language_name]
    exercise_name = 'Yahtzee'
    exercise = @dojo.exercises[exercise_name]
    #
    kata = @dojo.make_kata(language,exercise)
    #
    manifest = kata.manifest
    assert_equal manifest['exercise'], exercise_name
    assert_equal manifest['language'], language_name
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.make_kata in .json format" do
    kata = @dojo.make_kata(@language,@exercise)
    manifest = kata.manifest
    assert_equal manifest['exercise'], @exercise.name
    assert_equal manifest['language'], @language.name
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas[id]" do
    kata = @dojo.make_kata(@language,@exercise)
    k = @dojo.katas[kata.id]
    assert_not_nil k
    assert_equal k.id, kata.id
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas.each forwards to katas_each on paas" do
    kata = @dojo.make_kata(@language,@exercise)
    kata = @dojo.make_kata(@language,@exercise)
    katas = @dojo.katas.map {|kata| kata.id}
    assert_equal 2, katas.size
    assert katas.all?{|id| id.length == 10}
  end

  #- - - - - - - - - - - - - - - -

=begin
  test "dojo.katas[id].start_avatar" do
    kata = @dojo.katas['ABCDE12345']
    avatar = kata.start_avatar
    assert_equal ExposedLinux::Avatar, avatar.class
    assert_equal 'lion', avatar.name
  end
=end


end
