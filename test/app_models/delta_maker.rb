
require_relative '../../app/lib/file_delta_maker'

class DeltaMaker

  include FileDeltaMaker

  def initialize(avatar)
    @avatar = avatar
    @was = avatar.visible_files
    @now = avatar.visible_files
  end

  attr_reader :was, :now

  def file?(filename)
    @now.keys.include?(filename)
  end

  def content(filename)
    @now[filename]
  end

  def new_file(filename, content)
    refute { file?(filename) }
    @now[filename] = content
  end

  def delete_file(filename)
    assert { file?(filename) }
    @now.delete(filename)
  end

  def change_file(filename, content)
    assert { file?(filename) }
    refute { @now[filename] == content }
    @now[filename] = content
  end

  def stub_colour(colour)
    root = File.expand_path(File.dirname(__FILE__)) + '/../app_lib/test_output'
    path = "#{root}/#{@avatar.kata.language.unit_test_framework}/#{colour}"
    all_outputs = Dir.glob(path + '/*')
    filename = all_outputs.sample
    output = File.read(filename)
    @avatar.runner.stub_run_output(@avatar, output)
  end

  def run_test(at = time_now)
    visible_files = now
    delta = make_delta(@was, @now)
    output = @avatar.test(delta, visible_files)
    colour = @avatar.language.colour(output)
    @avatar.katas.avatar_ran_tests(@avatar, delta, visible_files, at, output, colour)
    [delta, visible_files, output]
  end

  def test_args
    [delta, visible_files]
  end

  def delta
    make_delta(@was, @now)
  end

  def visible_files
    now
  end

  private

  include TimeNow

  def assert(&pred)
    fail RuntimeError.new('DeltaMaker.assert') unless pred.call
  end

  def refute(&pred)
    fail RuntimeError.new('DeltaMaker.refute') if pred.call
  end

end
