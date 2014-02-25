
class SpyDir

  def initialize(dir)
    @dir = dir
    @read_log = [ ]
    @write_log = [ ]
  end

  def exists?(filename = "")
    @read_repo != nil && (filename == "" || @read_repo[filename] != nil)
  end

  def make
    @read_repo ||= { }
  end

  def write(filename, content)
    if filename.end_with?(".rb")
      assert content.class != String, "write(#{filename},content.class != String)"
      content = content.inspect
    end
    if filename.end_with?(".json")
      assert content.class != String, "write(#{filename},content.class != String)"
      content = JSON.unparse(content)
    end
    @write_log << [filename, content]
    make
    @read_repo[filename] = content
  end

  def read(filename)
    assert @read_repo != nil, "read(#{filename}) not stubbed"
    @read_log << [filename]
    @read_repo[filename]
  end

  def lock(&block)
    block.call
  end

  # - - - - - - - - - - - - - - -

  def spy_read(filename,content)
    make
    @read_repo[filename] = content
  end

  def write_log
    @write_log
  end

  def read_log
    @read_log
  end

private

  def assert(truth, message)
    if !truth
      raise "SpyDir[#{@dir}].#{message}"
    end
  end

end
