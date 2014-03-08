require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../../lib/disk'
require File.dirname(__FILE__) + '/../../lib/git'
require File.dirname(__FILE__) + '/../../lib/runner'

class KatasTests < ActionController::TestCase

  def set_paas(format)
    @disk = Disk.new
    @git = Git.new
    @runer = Runner.new
    @paas = ExposedLinux::Paas.new(@disk, @git, @runner)
    @format = format
    @dojo = @paas.create_dojo(root_path, @format)
    @language = @dojo.languages['Java-JUnit']
    @exercise = @dojo.exercises['Yahtzee']
    `rm -rf #{@paas.path(@dojo.katas)}`
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.make_kata in .rb format" do
    set_paas('rb')
    #
    kata = @dojo.make_kata(@language, @exercise)
    #
    manifest = kata.manifest
    assert_equal manifest['exercise'], @exercise.name
    assert_equal manifest['language'], @language.name
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.make_kata in .json format" do
    set_paas('json')
    kata = @dojo.make_kata(@language, @exercise)
    manifest = kata.manifest
    assert_equal manifest['exercise'], @exercise.name
    assert_equal manifest['language'], @language.name
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas[id] returns previously created kata with given id" do
    set_paas('json')
    kata = @dojo.make_kata(@language, @exercise)
    k = @dojo.katas[kata.id]
    assert_not_nil k
    assert_equal k.id, kata.id
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas.each() returns all currently created katas by forwarding to paas.katas_each()" do
    set_paas('json')
    kata = @dojo.make_kata(@language, @exercise)
    kata = @dojo.make_kata(@language, @exercise)
    katas = @dojo.katas.map {|kata| kata.id}
    assert_equal 2, katas.size
    assert katas.all?{|id| id.length == 10}
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas[id].start_avatar" do
    set_paas('json')
    kata = @dojo.make_kata(@language, @exercise)
    avatar = kata.start_avatar
    assert_not_nil avatar
    text = @paas.dir(avatar).read(avatar.visible_files_filename)
    visible_files = JSON.parse(text)
    assert visible_files.keys.include?('cyber-dojo.sh')
    text = @paas.dir(avatar.sandbox).read('cyber-dojo.sh')
    assert_not_nil text
  end

  #- - - - - - - - - - - - - - - -


end
