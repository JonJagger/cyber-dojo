
require_relative '../../app/lib/FileDeltaMaker'

class DeltaMaker

  include FileDeltaMaker

  def initialize(avatar)
    @avatar = avatar
    @was = avatar.visible_files
    @now = avatar.visible_files
  end

  attr_reader :was,:now

  def new_file(filename,content)
    refute { @was.keys.include?(filename) }
    @now[filename] = content
  end

  def delete_file(filename)
    assert { @was.keys.include?(filename) }
    @now.delete(filename)
  end

  def change_file(filename,content)
    assert { @was.keys.include?(filename) }
    refute { @was[filename] == content }
    @now[filename] = content
  end

  def run_test
    delta = make_delta(@was,@now)
    visible_files = now
    _,output = @avatar.test(delta, visible_files)
    [delta,visible_files,output]
  end

  def test_args
    [make_delta(@was,@now),now]
  end

private
  
  def assert(&block)
    raise RuntimeError.new('DeltaMaker.assert') if !block.call
  end

  def refute(&block)
    raise RuntimeError.new('DeltaMaker.refute') if block.call
  end

end
