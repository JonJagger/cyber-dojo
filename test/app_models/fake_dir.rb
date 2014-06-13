
class FakeDir
  include Enumerable

  def initialize(disk, dir)
    @disk,@dir = disk,dir
  end

  def path
    @dir
  end

  def each
    @disk.subdirs_each(self) do |subdir|
      yield subdir
    end
  end

  def make
    @repo ||= { }
  end

  # - - - - - - - - - - - - - - -

  def exists?(filename = '')
    return false if @repo === nil   # no mk_dir -> dir().make yet
    return true  if filename === '' # the repo exists for the dir
    return @repo[filename] != nil
  end

  # - - - - - - - - - - - - - - -

  def write(filename, content)
    if filename.end_with?('.rb')
      assert content.class != String, "write('#{filename}',content.class != String)"
      content = content.inspect
    end
    if filename.end_with?(".json")
      assert content.class != String, "write('#{filename}',content.class != String)"
      content = JSON.unparse(content)
    end
    make
    @repo[filename] = content
  end

  # - - - - - - - - - - - - - - -

  def read(filename)
    assert @repo != nil, "read('#{filename}') no file"
    assert @repo[filename] != nil, "read('#{filename}') no file"
    content  = @repo[filename]
    content
  end

  # - - - - - - - - - - - - - - -

  def lock(&block)
    block.call
  end

private

  def assert(truth, message)
    if !truth
      raise "FakeDir['#{@dir}'].#{message}"
    end
  end

end
