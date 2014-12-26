
class FakeDir
  include Enumerable

  def initialize(disk,dir)
    @disk,@dir = disk,dir
  end

  def path
    @dir
  end

  def each
    @disk.subdirs_each(self) do |subdir|
      yield subdir,File.join(path,subdir)
    end
  end

  def make
    @repo ||= { }
  end

  # - - - - - - - - - - - - - - -

  def exists?(filename = '')
    return false if @repo.nil?      # no mk_dir -> dir().make yet
    return true  if filename === '' # the repo exists for the dir
    return !@repo[filename].nil?
  end

  # - - - - - - - - - - - - - - -

  def write(filename, content)
    if filename.end_with?('.rb')
      assert_not_string(content,filename)
      content = content.inspect
    end
    if filename.end_with?(".json")
      assert_not_string(content,filename)
      content = JSON.unparse(content)
    end
    make
    @repo[filename] = content
  end

  # - - - - - - - - - - - - - - -

  def read(filename)
    assert !@repo.nil?, "read('#{filename}') no file"
    assert !@repo[filename].nil?, "read('#{filename}') no file"
    content = @repo[filename]
    content
  end

  # - - - - - - - - - - - - - - -

  def lock(&block)
    block.call
  end

private

  def assert_not_string(content,filename)
    assert content.class != String,
      "write('#{filename}',content.class != String)"
  end

  def assert(truth, message)
    raise "FakeDir['#{@dir}'].#{message}" if !truth
  end

end
