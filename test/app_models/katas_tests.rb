__DIR__ = File.dirname(__FILE__) + '/../../'
require __DIR__ + 'test/test_helper'
require __DIR__ + 'lib/OsDisk'
require __DIR__ + 'lib/Git'
require __DIR__ + 'app/lib/HostRunner'

class KatasTests < ActionController::TestCase

  def set_paas(format)
    @disk  = OsDisk.new
    @git   = Git.new
    @runer = HostRunner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = format
    @dojo = @paas.create_dojo(root_path, @format)
    @language = @dojo.languages['test-Java-JUnit']
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
    assert_equal manifest['id'], kata.id.to_s
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
    assert_equal manifest['id'], kata.id.to_s
    assert_equal manifest['exercise'], @exercise.name
    assert_equal manifest['language'], @language.name
    assert_equal manifest['unit_test_framework'], @language.unit_test_framework
    assert_equal manifest['tab_size'], @language.tab_size
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas[id] returns previously created kata with given id" do
    set_paas('json')
    kata = @dojo.make_kata(@language, @exercise)
    k = @dojo.katas[kata.id.to_s]
    assert_not_nil k
    assert_equal k.id.to_s, kata.id.to_s
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas.each() returns all currently created katas by forwarding to paas.katas_each()" do
    set_paas('json')
    kata1 = @dojo.make_kata(@language, @exercise, Id.new.to_s)
    kata2 = @dojo.make_kata(@language, @exercise, Id.new.to_s)
    katas_ids = @dojo.katas.map {|kata| kata.id.to_s}
    assert_equal [kata1.id.to_s,kata2.id.to_s].sort, @dojo.katas.map{|kata| kata.id.to_s}.sort
  end

  #- - - - - - - - - - - - - - - -

  test "dojo.katas[id].start_avatar" do
    set_paas('json')
    kata = @dojo.make_kata(@language, @exercise)
    avatar = kata.start_avatar
    assert_not_nil avatar
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('cyber-dojo.sh')
    text = @paas.read(avatar.sandbox, 'cyber-dojo.sh')
    assert_not_nil text
  end

end
