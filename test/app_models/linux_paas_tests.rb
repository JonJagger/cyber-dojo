__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/../app_models/spy_disk'
require __DIR__ + '/../app_models/stub_git'
require __DIR__ + '/../app_models/stub_runner'
require 'LinuxPaas'

class LinxuPaasTests < ActionController::TestCase

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

  test "path(exercise) is based on exercise.name" do
    rb_and_json(&Proc.new{|format|
      exercise = @dojo.exercises['Yahtzee']
      assert @paas.path(exercise).match(exercise.name)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(exercise) ends in a slash" do
    rb_and_json(&Proc.new{|format|
      exercise = @dojo.exercises['Yahtzee']
      assert @paas.path(exercise).end_with?(@disk.dir_separator)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(exercise) does not have doubled separator" do
    rb_and_json(&Proc.new{|format|
      exercise = @dojo.exercises['Yahtzee']
      doubled_separator = @disk.dir_separator * 2
      assert_equal 0, @paas.path(exercise).scan(doubled_separator).length
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(language) is based on language.name" do
    rb_and_json(&Proc.new{|format|
      language = @dojo.languages['Ruby']
      assert @paas.path(language).match(language.name)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(language) ends in a slash" do
    rb_and_json(&Proc.new{|format|
      language = @dojo.languages['Ruby']
      assert @paas.path(language).end_with?(@disk.dir_separator)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(language) does not have doubled separator" do
    rb_and_json(&Proc.new{|format|
      language = @dojo.languages['Ruby']
      doubled_separator = @disk.dir_separator * 2
      assert_equal 0, @paas.path(language).scan(doubled_separator).length
    })
  end


end
