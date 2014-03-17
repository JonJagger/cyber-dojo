__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/../../lib/disk'
require __DIR__ + '/../../lib/git'
require __DIR__ + '/../../lib/runner'

class LinuxPaasKatasTests < ActionController::TestCase

  def set_paas(format)
    @disk = Disk.new
    @git = Git.new
    @runer = Runner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = format
    @dojo = @paas.create_dojo(root_path, @format)
    @language = @dojo.languages['Java-JUnit']
    @exercise = @dojo.exercises['Yahtzee']
    `rm -rf #{@paas.path(@dojo.katas)}`
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.make_kata in .rb format" do
    set_paas('rb')
    assert_equal 'rb', @dojo.format
    assert @dojo.format_is_rb?
    assert !@dojo.format_is_json?
    #
    kata = @dojo.make_kata(@language, @exercise)
    assert_equal 'rb', kata.format
    assert kata.format_is_rb?
    assert !kata.format_is_json?
    assert_equal @language.name, kata.language.name
    assert_equal @exercise.name, kata.exercise.name
    #
    manifest = kata.manifest
    assert_equal manifest['id'], kata.id
    assert_equal manifest['exercise'], @exercise.name
    assert_equal manifest['language'], @language.name
    assert_equal manifest['unit_test_framework'], @language.unit_test_framework
    assert_equal manifest['tab_size'], @language.tab_size
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.make_kata in .json format" do
    set_paas('json')
    assert_equal 'json', @dojo.format
    assert !@dojo.format_is_rb?
    assert @dojo.format_is_json?
    #
    kata = @dojo.make_kata(@language, @exercise)
    assert_equal 'json', kata.format
    assert !kata.format_is_rb?
    assert kata.format_is_json?
    assert_equal @language.name, kata.language.name
    assert_equal @exercise.name, kata.exercise.name
    #
    manifest = kata.manifest
    assert_equal manifest['id'], kata.id
    assert_equal manifest['exercise'], @exercise.name
    assert_equal manifest['language'], @language.name
    assert_equal manifest['unit_test_framework'], @language.unit_test_framework
    assert_equal manifest['tab_size'], @language.tab_size
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
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('cyber-dojo.sh')
    text = @paas.disk_read(avatar.sandbox, 'cyber-dojo.sh')
    assert_not_nil text
  end

end
