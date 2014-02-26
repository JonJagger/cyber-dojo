
class SpyDir

  def initialize(dir)
    @dir = dir
    @log = [ ]
  end

  def teardown
    assert @log != [ ], "read/write() never called"
    #@repo.keys.each do |filename|
    #  assert @read_log.include?(filename),
    #        "spy_read('#{filename}',...) but no .read('#{filename}')"
    #end
  end

  def path
    @dir
  end

  def exists?(filename = "")
    @repo != nil && (filename == "" || @repo[filename] != nil)
  end

  def make
    @repo ||= { }
  end

  def write(filename, content)
    if filename.end_with?(".rb")
      assert content.class != String, "write('#{filename}',content.class != String)"
      content = content.inspect
    end
    if filename.end_with?(".json")
      assert content.class != String, "write('#{filename}',content.class != String)"
      content = JSON.unparse(content)
    end
    @log << ['write',filename,content]
    make
    @repo[filename] = content
  end

  def read(filename)
    assert @repo != nil, "read('#{filename}') no files stubbed"
    assert @repo[filename] != nil, "read('#{filename}') not stubbed"
    content  = @repo[filename]
    @log << ['read',filename,content]
    content
  end

  def lock(&block)
    block.call
  end

  # - - - - - - - - - - - - - - -

  def spy_read(filename,content)
    make
    @repo[filename] = content
  end

  def log
    @log
  end

private

  def assert(truth, message)
    if !truth
      raise "SpyDir['#{@dir}'].#{message}"
    end
  end

end
