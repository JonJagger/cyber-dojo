__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/../app_models/spy_disk'
require __DIR__ + '/../app_models/stub_git'
require __DIR__ + '/../app_models/stub_runner'
require 'LinuxPaas'

class LinxuPaasExerciseTests < ActionController::TestCase

  def setup
    setup_format('rb')
  end

  def setup_format(format)
    @disk = SpyDisk.new
    @git = StubGit.new
    @runner = StubRunner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = format
    @dojo = @paas.create_dojo(root_path + '../../', @format)
  end

  def teardown
    @disk.teardown
  end

  def rb_and_json(&block)
    block.call('rb')
    teardown
    setup_format('json')
    block.call('json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "name is as set in ctor" do
    rb_and_json(&Proc.new{|format|
      exercise = @dojo.exercises['Yahtzee']
      assert_equal 'Yahtzee', exercise.name
    })
  end

  test "instructions are loaded" do
    rb_and_json(&Proc.new{|format|
      exercise = @dojo.exercises['Yahtzee']
      filename = 'instructions'
      content = 'fishing for Salmon on the Verdal'
      @paas.dir(exercise).spy_read(filename, content)
      assert_equal content, exercise.instructions
      assert @paas.dir(exercise).log.include?(['read',filename,content])
    })
  end

end
